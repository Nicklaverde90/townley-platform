from __future__ import annotations

from datetime import datetime

from sqlalchemy import DateTime, Integer, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class WorkOrderAudit(Base):
    __tablename__ = "WorkOrderAudit"

    id: Mapped[int] = mapped_column("Id", Integer, primary_key=True, autoincrement=True)
    action: Mapped[str] = mapped_column("Action", String(32), nullable=False)
    record_no: Mapped[int] = mapped_column("RecordNo", Integer, nullable=False)
    before_json: Mapped[str | None] = mapped_column("BeforeJson", Text, nullable=True)
    after_json: Mapped[str | None] = mapped_column("AfterJson", Text, nullable=True)
    user_email: Mapped[str | None] = mapped_column("UserEmail", String(255), nullable=True)
    occurred_at: Mapped[datetime] = mapped_column("AtUtc", DateTime(timezone=False), server_default=func.now())
