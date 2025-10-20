from sqlalchemy import Column, DateTime, Integer, String, Text, func

from app.core.db import Base


class WorkOrderAudit(Base):
    __tablename__ = "WorkOrderAudit"

    id = Column("Id", Integer, primary_key=True, autoincrement=True)
    action = Column("Action", String(32), nullable=False)
    record_no = Column("RecordNo", Integer, nullable=False)
    before_json = Column("BeforeJson", Text, nullable=True)
    after_json = Column("AfterJson", Text, nullable=True)
    user_email = Column("UserEmail", String(255), nullable=True)
    occurred_at = Column(
        "AtUtc", DateTime(timezone=False), nullable=False, server_default=func.now()
    )
