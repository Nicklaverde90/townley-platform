from __future__ import annotations

from datetime import datetime, timedelta, timezone

from jose import jwt
from passlib.context import CryptContext

from .config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)


def create_access_token(sub: str, expires_minutes: int | None = None) -> str:
    lifetime = expires_minutes or settings.access_token_expire_minutes
    now = datetime.now(timezone.utc)
    expire_at = now + timedelta(minutes=lifetime)
    payload = {"sub": sub, "exp": expire_at}
    return jwt.encode(payload, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
