from pydantic import BaseModel, Field
from typing import List, Optional, Literal


class WorkOrderBase(BaseModel):
    Status: Optional[str] = None
    Description: str = Field(..., min_length=1, max_length=1000)


class WorkOrderCreate(WorkOrderBase):
    pass


class WorkOrderUpdate(BaseModel):
    Status: Optional[str] = None
    Description: Optional[str] = Field(None, min_length=1, max_length=1000)


class WorkOrderRead(BaseModel):
    RecordNo: int
    Status: Optional[str] = None
    Description: Optional[str] = None
    CreatedAt: Optional[str] = None

    class Config:
        from_attributes = True


class WorkOrderListResponse(BaseModel):
    items: List[WorkOrderRead]
    total: int = Field(..., description="Total number of matching work orders")
    page: int
    page_size: int
    sort_by: Literal["RecordNo", "CreatedAt"]
    sort_dir: Literal["asc", "desc"]
