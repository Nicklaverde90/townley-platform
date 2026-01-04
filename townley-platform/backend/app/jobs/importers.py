import csv
import io
import json
from typing import Any, Dict
from sqlalchemy.orm import Session
from app.core.db import SessionLocal
from app.models.workorders import WorkOrder
from app.models.workorder_audit import WorkOrderAudit
from rq import get_current_job


def _set_progress(job, value: int):
    if job:
        job.meta["progress"] = value
        job.save_meta()


def import_workorders_csv(file_bytes: bytes, user_email: str) -> Dict[str, Any]:
    job = get_current_job()
    _set_progress(job, 1)
    text = file_bytes.decode("utf-8", errors="replace")
    reader = csv.DictReader(io.StringIO(text))
    total = 0
    upserts = 0
    errors = []

    db: Session = SessionLocal()
    try:
        rows = list(reader)
        total = len(rows)
        for idx, row in enumerate(rows, start=1):
            raw_record = row.get("RecordNo")
            try:
                record_no = int(raw_record) if raw_record is not None else None
            except (TypeError, ValueError):
                record_no = None
            if record_no is None:
                errors.append(f"Row {idx}: invalid RecordNo")
                continue

            status = row.get("Status") or None
            desc = row.get("Description") or None

            wo = db.query(WorkOrder).filter(WorkOrder.RecordNo == record_no).first()
            before = None

            if wo:
                before = {
                    "RecordNo": wo.RecordNo,
                    "Status": wo.Status,
                    "Description": wo.Description,
                    "CreatedAt": str(wo.CreatedAt) if wo.CreatedAt else None,
                }
                wo.Status = status
                wo.Description = desc
                upserts += 1
                action = "update"
            else:
                wo = WorkOrder(RecordNo=record_no, Status=status, Description=desc)
                db.add(wo)
                upserts += 1
                action = "create"

            db.flush()

            audit = WorkOrderAudit(
                action=action,
                record_no=record_no,
                before_json=json.dumps(before) if before else None,
                after_json=json.dumps(
                    {
                        "RecordNo": wo.RecordNo,
                        "Status": wo.Status,
                        "Description": wo.Description,
                        "CreatedAt": str(wo.CreatedAt) if wo.CreatedAt else None,
                    }
                ),
                user_email=user_email,
            )
            db.add(audit)

            if idx % 50 == 0:
                db.commit()

            if total:
                _set_progress(job, int(1 + (idx / total) * 98))

        db.commit()
    finally:
        db.close()

    _set_progress(job, 100)
    return {"total": total, "upserts": upserts, "errors": errors}
