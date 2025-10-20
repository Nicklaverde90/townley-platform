import csv
import io
import json
from fastapi import APIRouter, Depends, Response, HTTPException
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.core.admin_deps import require_admin
from app.models.workorders import WorkOrders
from app.models.workorder_audit import WorkOrderAudit

router = APIRouter(prefix="/api/workorders", tags=["workorders"])


@router.get("/export")
def export_csv(db: Session = Depends(get_db), _user=Depends(require_admin)):
    rows = db.query(WorkOrders).order_by(WorkOrders.RecordNo.asc()).all()
    buf = io.StringIO()
    writer = csv.writer(buf)
    writer.writerow(["RecordNo", "Status", "Description", "CreatedAt"])
    for r in rows:
        writer.writerow(
            [r.RecordNo, r.Status or "", r.Description or "", r.CreatedAt or ""]
        )
    data = buf.getvalue().encode("utf-8")
    headers = {"Content-Disposition": 'attachment; filename="workorders.csv"'}
    return Response(content=data, media_type="text/csv; charset=utf-8", headers=headers)


@router.delete("/{record_no}/hard-delete", status_code=204)
def hard_delete(
    record_no: int, db: Session = Depends(get_db), user=Depends(require_admin)
):
    wo = db.query(WorkOrders).filter(WorkOrders.RecordNo == record_no).first()
    if not wo:
        raise HTTPException(status_code=404, detail="Work order not found")
    before = {
        "RecordNo": wo.RecordNo,
        "Status": wo.Status,
        "Description": wo.Description,
        "CreatedAt": str(wo.CreatedAt) if wo.CreatedAt else None,
    }
    db.delete(wo)
    audit = WorkOrderAudit(
        action="delete",
        record_no=record_no,
        before_json=json.dumps(before),
        after_json=None,
        user_email=user.email,
    )
    db.add(audit)
    db.commit()
    return Response(status_code=204)
