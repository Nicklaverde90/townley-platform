from typing import Optional, Literal
from fastapi import APIRouter, Depends, Query, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import or_, asc, desc
from app.core.db import get_db
from app.core.deps import get_current_user
from app.core.admin_deps import require_admin
from app.models.workorders import WorkOrders
from app.schemas.workorders import (
    WorkOrderListResponse, WorkOrderRead, WorkOrderCreate, WorkOrderUpdate
)

router = APIRouter(prefix="/api/workorders", tags=["workorders"])

@router.get("", response_model=WorkOrderListResponse)
def list_workorders(
    q: Optional[str] = Query(None, description="Search by RecordNo or Description"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    sort_by: Literal["RecordNo","CreatedAt"] = Query("RecordNo"),
    sort_dir: Literal["asc","desc"] = Query("desc"),
    db: Session = Depends(get_db),
    _user = Depends(get_current_user)
):
    query = db.query(WorkOrders)
    if q:
        q_like = f"%{q}%"
        conditions = [WorkOrders.Description.ilike(q_like)]
        if q.isdigit():
            conditions.append(WorkOrders.RecordNo == int(q))
        query = query.filter(or_(*conditions))
    total = query.count()

    order_col = WorkOrders.RecordNo if sort_by == "RecordNo" else WorkOrders.CreatedAt
    order_func = asc if sort_dir == "asc" else desc
    items = (
        query
        .order_by(order_func(order_col))
        .offset((page - 1) * page_size)
        .limit(page_size)
        .all()
    )
    return WorkOrderListResponse(
        items=items, total=total, page=page, page_size=page_size,
        sort_by=sort_by, sort_dir=sort_dir
    )

@router.post("", response_model=WorkOrderRead, status_code=status.HTTP_201_CREATED)
def create_workorder(
    payload: WorkOrderCreate,
    db: Session = Depends(get_db),
    _admin = Depends(require_admin),
):
    wo = WorkOrders(Status=payload.Status, Description=payload.Description)
    db.add(wo)
    db.commit()
    db.refresh(wo)
    return wo

@router.put("/{record_no}", response_model=WorkOrderRead)
def update_workorder(
    record_no: int,
    payload: WorkOrderUpdate,
    db: Session = Depends(get_db),
    _admin = Depends(require_admin),
):
    wo = db.query(WorkOrders).filter(WorkOrders.RecordNo == record_no).first()
    if not wo:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Work order not found")
    if payload.Status is not None:
        wo.Status = payload.Status
    if payload.Description is not None:
        wo.Description = payload.Description
    db.add(wo)
    db.commit()
    db.refresh(wo)
    return wo
