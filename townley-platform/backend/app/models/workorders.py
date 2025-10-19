from __future__ import annotations

from datetime import datetime

from sqlalchemy import DateTime, Integer, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from .base import Base


class WorkOrders(Base):
    __tablename__ = "work_orders"

    RecordNo: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    Status: Mapped[str | None] = mapped_column(String(50), nullable=True)
    Description: Mapped[str | None] = mapped_column(Text, nullable=True)
    CreatedAt: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), default=datetime.utcnow
    )
