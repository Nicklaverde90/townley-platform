from fastapi import Depends, HTTPException, status

from app.core.deps import get_current_user
from app.models.users import User


def require_admin(user: User = Depends(get_current_user)) -> User:
    if not getattr(user, "is_admin", False):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Admin privileges required")
    return user
