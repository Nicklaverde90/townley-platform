from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime


class AuditEntry(BaseModel):
    id: int
    record_no: int
    action: str
    changed_by: Optional[str] = None
    changed_at: datetime
    details: Optional[str] = None

    class Config:
        from_attributes = True


class AuditListResponse(BaseModel):
    items: List[AuditEntry]
    total: int
    page: int
    page_size: int
