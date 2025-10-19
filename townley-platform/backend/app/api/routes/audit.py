from typing import Optional, List
from fastapi import APIRouter, Depends, Query, Response
from sqlalchemy.orm import Session
from sqlalchemy import and_
from datetime import datetime
import csv, io

from app.core.db import get_db
from app.core.admin_deps import require_admin  # assumes exist from previous patch
from app.models.workorder_audit import WorkOrderAudit  # assumes exist from previous patch
from app.schemas.audit import AuditListResponse, AuditEntry

router = APIRouter(prefix="/api/audit", tags=["audit"])

@router.get("/workorders", response_model=AuditListResponse)
def list_audit_workorders(
    action: Optional[str] = Query(None, description="Filter by action: create|update|delete|import"),
    record_no: Optional[int] = Query(None),
    start: Optional[datetime] = Query(None, description="ISO datetime start"),
    end: Optional[datetime] = Query(None, description="ISO datetime end"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    _admin = Depends(require_admin),
):
    q = db.query(WorkOrderAudit)
    clauses = []
    if action:
        clauses.append(WorkOrderAudit.action == action)
    if record_no is not None:
        clauses.append(WorkOrderAudit.record_no == record_no)
    if start:
        clauses.append(WorkOrderAudit.changed_at >= start)
    if end:
        clauses.append(WorkOrderAudit.changed_at <= end)
    if clauses:
        q = q.filter(and_(*clauses))
    total = q.count()
    items = (
        q.order_by(WorkOrderAudit.changed_at.desc())
        .offset((page - 1) * page_size)
        .limit(page_size)
        .all()
    )
    return AuditListResponse(
        items=items, total=total, page=page, page_size=page_size
    )

@router.get("/workorders/export")
def export_audit_workorders_csv(
    action: Optional[str] = Query(None),
    record_no: Optional[int] = Query(None),
    start: Optional[datetime] = Query(None),
    end: Optional[datetime] = Query(None),
    db: Session = Depends(get_db),
    _admin = Depends(require_admin),
):
    q = db.query(WorkOrderAudit)
    clauses = []
    if action:
        clauses.append(WorkOrderAudit.action == action)
    if record_no is not None:
        clauses.append(WorkOrderAudit.record_no == record_no)
    if start:
        clauses.append(WorkOrderAudit.changed_at >= start)
    if end:
        clauses.append(WorkOrderAudit.changed_at <= end)
    if clauses:
        q = q.filter(and_(*clauses))
    rows = q.order_by(WorkOrderAudit.changed_at.desc()).all()
    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["Id", "RecordNo", "Action", "ChangedBy", "ChangedAt", "Details"])
    for r in rows:
        writer.writerow([r.id, r.record_no, r.action, r.changed_by or "", r.changed_at.isoformat(), r.details or ""])
    data = output.getvalue()
    headers = {
        "Content-Type": "text/csv; charset=utf-8",
        "Content-Disposition": "attachment; filename=audit_workorders.csv",
    }
    return Response(content=data, headers=headers)