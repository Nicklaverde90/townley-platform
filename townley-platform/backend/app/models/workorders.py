from __future__ import annotations

from datetime import datetime

from sqlalchemy import Column, DateTime, Integer, String, Text, func

from .base import Base


class WorkOrders(Base):
    __tablename__ = "work_orders"

    RecordNo = Column(Integer, primary_key=True, autoincrement=True)
    Status = Column(String(50), nullable=True)
    Description = Column(Text, nullable=True)
    CreatedAt = Column(
        DateTime(timezone=True), server_default=func.now(), default=datetime.utcnow
    )
