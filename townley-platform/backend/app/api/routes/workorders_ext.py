import csv
import io
from datetime import datetime
from typing import Optional

from fastapi import APIRouter, Depends, File, HTTPException, Query, UploadFile, status
from sqlalchemy import or_
from sqlalchemy.orm import Session

from app.core.admin_deps import require_admin
from app.core.db import get_db
from app.core.deps import get_current_user
from app.models.workorders import WorkOrders
from app.schemas.workorders import WorkOrderListResponse

router = APIRouter(prefix="/api/workorders", tags=["workorders"])


@router.get("", response_model=WorkOrderListResponse)
def list_workorders(
    q: Optional[str] = Query(None, description="Search by RecordNo or Description"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    include_deleted: bool = Query(False),
    db: Session = Depends(get_db),
    _user=Depends(get_current_user),
) -> WorkOrderListResponse:
    query = db.query(WorkOrders)
    if not include_deleted:
        query = query.filter(WorkOrders.DeletedAt.is_(None))
    if q:
        q_like = f"%{q}%"
        conditions = [WorkOrders.Description.ilike(q_like)]
        if q.isdigit():
            conditions.append(WorkOrders.RecordNo == int(q))
        query = query.filter(or_(*conditions))
    total = query.count()
    items = (
        query.order_by(WorkOrders.RecordNo.desc())
        .offset((page - 1) * page_size)
        .limit(page_size)
        .all()
    )
    return WorkOrderListResponse(
        items=items, total=total, page=page, page_size=page_size
    )


@router.delete("/{record_no}", status_code=204)
def delete_workorder(
    record_no: int,
    db: Session = Depends(get_db),
    _admin=Depends(require_admin),
) -> None:
    wo = (
        db.query(WorkOrders)
        .filter(WorkOrders.RecordNo == record_no, WorkOrders.DeletedAt.is_(None))
        .first()
    )
    if not wo:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Work order not found"
        )
    wo.DeletedAt = datetime.utcnow()
    db.add(wo)
    db.commit()


@router.post("/{record_no}/restore", status_code=204)
def restore_workorder(
    record_no: int,
    db: Session = Depends(get_db),
    _admin=Depends(require_admin),
) -> None:
    wo = (
        db.query(WorkOrders)
        .filter(WorkOrders.RecordNo == record_no, WorkOrders.DeletedAt.is_not(None))
        .first()
    )
    if not wo:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Work order not found or not deleted",
        )
    wo.DeletedAt = None
    db.add(wo)
    db.commit()


@router.post("/import", status_code=201)
async def import_csv(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    _admin=Depends(require_admin),
) -> dict[str, int]:
    if not file.filename.endswith(".csv"):
        raise HTTPException(status_code=400, detail="CSV file required")
    content = await file.read()
    reader = csv.DictReader(io.StringIO(content.decode("utf-8-sig")))
    required = {"RecordNo"}
    if not required.issubset(set(reader.fieldnames or [])):
        raise HTTPException(status_code=400, detail="Missing required headers")

    upserted = 0
    for row in reader:
        try:
            record_no = int(row["RecordNo"])
        except Exception:
            continue
        status_value = row.get("Status") or None
        desc_value = row.get("Description") or None
        created_value = row.get("CreatedAt") or None

        created_dt: Optional[datetime] = None
        if created_value:
            for fmt in ("%Y-%m-%dT%H:%M:%S", "%Y-%m-%d %H:%M:%S"):
                try:
                    created_dt = datetime.strptime(created_value, fmt)
                    break
                except ValueError:
                    continue

        wo = db.query(WorkOrders).filter(WorkOrders.RecordNo == record_no).first()
        if not wo:
            wo = WorkOrders(RecordNo=record_no)
        wo.Status = status_value
        wo.Description = desc_value
        if created_dt:
            wo.CreatedAt = created_dt
        wo.DeletedAt = None
        db.add(wo)
        upserted += 1

    db.commit()
    return {"upserted": upserted}
