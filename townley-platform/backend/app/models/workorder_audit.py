from sqlalchemy import Column, Integer, String, Text, DateTime, func
from app.core.db import Base

class WorkOrderAudit(Base):
    __tablename__ = "WorkOrderAudit"
    Id = Column(Integer, primary_key=True, autoincrement=True)
    Action = Column(String(32), nullable=False)  # 'create' | 'update' | 'delete' | 'restore' | 'import'
    RecordNo = Column(Integer, nullable=False)
    BeforeJson = Column(Text, nullable=True)
    AfterJson = Column(Text, nullable=True)
    UserEmail = Column(String(255), nullable=True)
    AtUtc = Column(DateTime, nullable=False, server_default=func.now())