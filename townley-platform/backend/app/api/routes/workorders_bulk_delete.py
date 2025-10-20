from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.core.admin_deps import require_admin  # admin-only
from app.models.workorders import WorkOrders
from app.models.workorder_audit import WorkOrderAudit
from app.core.deps import get_current_user

router = APIRouter(prefix="/api/workorders", tags=["workorders"])


@router.post("/hard-delete-bulk")
def hard_delete_bulk(
    record_nos: List[int],
    db: Session = Depends(get_db),
    admin=Depends(require_admin),
    user=Depends(get_current_user),
):
    # Delete in chunks to avoid locks
    deleted = 0
    for rec in record_nos:
        obj = db.query(WorkOrders).filter(WorkOrders.RecordNo == rec).first()
        if obj:
            db.delete(obj)
            db.add(
                WorkOrderAudit(
                    record_no=rec,
                    action="delete",
                    changed_by=user.email if hasattr(user, "email") else None,
                    details="bulk",
                )
            )
            deleted += 1
    db.commit()
    return {"deleted": deleted, "requested": len(record_nos)}
