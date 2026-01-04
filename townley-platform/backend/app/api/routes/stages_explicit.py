import json
from datetime import datetime, timezone
from typing import Any, Dict

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.core.deps_role import require_role
from app.core.roles import Role
from app.models.workorder_audit import WorkOrderAudit
from app.models.workorders import WorkOrder

router = APIRouter(tags=["stages"])


def _find_workorder_or_404(db: Session, record_no: int) -> WorkOrder:
    wo = db.query(WorkOrder).filter(WorkOrder.RecordNo == record_no).first()
    if not wo:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Work order not found"
        )
    return wo


def _write_audit(
    db: Session, record_no: int, user_email: str, stage: str, fields: Dict[str, Any]
) -> None:
    entry = WorkOrderAudit(
        record_no=record_no,
        action="stage_update",
        before_json=None,
        after_json=json.dumps({"stage": stage, "fields": fields}),
        user_email=user_email,
        occurred_at=datetime.now(timezone.utc),
    )
    db.add(entry)


def _handle_stage(
    db: Session, payload: Dict[str, Any], stage: str, user_email: str
) -> Dict[str, Any]:
    if "recordNo" not in payload:
        raise HTTPException(status_code=422, detail="recordNo is required")
    record_no = int(payload["recordNo"])
    _find_workorder_or_404(db, record_no)
    # Business logic placeholder: upsert into a stage table or attach to WorkOrder as needed.
    # For now we just audit the submission.
    fields = {k: v for k, v in payload.items() if k != "recordNo"}
    _write_audit(db, record_no, user_email, stage, fields)
    db.commit()
    return {"ok": True, "recordNo": record_no, "stage": stage, "fields": fields}


@router.post("/api/molding")
def submit_molding(
    payload: Dict[str, Any],
    db: Session = Depends(get_db),
    user=Depends(require_role(Role.editor)),
):
    return _handle_stage(db, payload, "Molding", user.email)


@router.post("/api/pouring")
def submit_pouring(
    payload: Dict[str, Any],
    db: Session = Depends(get_db),
    user=Depends(require_role(Role.editor)),
):
    return _handle_stage(db, payload, "Pouring", user.email)


@router.post("/api/heattreat")
def submit_heattreat(
    payload: Dict[str, Any],
    db: Session = Depends(get_db),
    user=Depends(require_role(Role.editor)),
):
    return _handle_stage(db, payload, "HeatTreat", user.email)


@router.post("/api/machining")
def submit_machining(
    payload: Dict[str, Any],
    db: Session = Depends(get_db),
    user=Depends(require_role(Role.editor)),
):
    return _handle_stage(db, payload, "Machining", user.email)


@router.post("/api/assembly")
def submit_assembly(
    payload: Dict[str, Any],
    db: Session = Depends(get_db),
    user=Depends(require_role(Role.editor)),
):
    return _handle_stage(db, payload, "Assembly", user.email)


@router.post("/api/inspection")
def submit_inspection(
    payload: Dict[str, Any],
    db: Session = Depends(get_db),
    user=Depends(require_role(Role.editor)),
):
    return _handle_stage(db, payload, "Inspection", user.email)


@router.post("/api/scrap")
def submit_scrap(
    payload: Dict[str, Any],
    db: Session = Depends(get_db),
    user=Depends(require_role(Role.editor)),
):
    return _handle_stage(db, payload, "Scrap", user.email)


@router.post("/api/chemistry")
def submit_chemistry(
    payload: Dict[str, Any],
    db: Session = Depends(get_db),
    user=Depends(require_role(Role.editor)),
):
    return _handle_stage(db, payload, "Chemistry", user.email)
