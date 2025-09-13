from fastapi import APIRouter, Depends
    from app.core.deps import get_current_user
    
    router = APIRouter(prefix="/api/users", tags=["users"])
    
    @router.get("/me")
    def me(user = Depends(get_current_user)):
        # Return minimal safe profile
        return {
            "email": user.email,
            "full_name": getattr(user, "full_name", None),
            "is_admin": getattr(user, "is_admin", False),
            "is_active": getattr(user, "is_active", True),
        }