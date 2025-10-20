from __future__ import annotations

from sqlalchemy import Boolean, Column, DateTime, Integer, String, func

from .base import Base


class User(Base):
    __tablename__ = "Users"

    id = Column(Integer, primary_key=True, autoincrement=True)
    email = Column(String(255), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    full_name = Column(String(255), nullable=True)
    is_active = Column(Boolean, nullable=False, server_default="1")
    is_admin = Column(Boolean, nullable=False, server_default="0")
    role = Column(String(16), nullable=False, server_default="viewer")
    created_at = Column(DateTime, nullable=False, server_default=func.now())
