from datetime import datetime, timezone
from typing import Optional
from fastapi import Depends, HTTPException, status, Query
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.models.users import Users
from app.core.config import settings
from app.core.roles import Role, role_at_least

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="api/auth/login")

def _decode_token(token: str) -> str:
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        sub: Optional[str] = payload.get("sub")
        exp: Optional[int] = payload.get("exp")
        if not sub or not exp or datetime.now(timezone.utc).timestamp() > exp:
            raise JWTError("invalid")
        return sub
    except JWTError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> Users:
    email = _decode_token(token)
    user = db.query(Users).filter(Users.email == email).first()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail="Inactive or missing user")
    return user

def require_role(min_role: Role):
    def dep(user: Users = Depends(get_current_user)) -> Users:
        if not role_at_least(getattr(user, "role", "viewer"), min_role.value):
            raise HTTPException(status_code=403, detail="Insufficient role")
        return user
    return dep

# Special for SSE where headers aren't available; accept token as query parameter.
def user_from_query_token(token: str = Query(...), db: Session = Depends(get_db)) -> Users:
    email = _decode_token(token)
    user = db.query(Users).filter(Users.email == email).first()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail="Inactive or missing user")
    return user