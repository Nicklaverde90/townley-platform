from enum import Enum


class Role(str, Enum):
    viewer = "viewer"
    editor = "editor"
    admin = "admin"


_order = {Role.viewer: 0, Role.editor: 1, Role.admin: 2}


def role_at_least(user_role: str, min_role: str) -> bool:
    try:
        return _order[Role(user_role)] >= _order[Role(min_role)]
    except Exception:
        return False
