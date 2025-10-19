from __future__ import annotations

import argparse
import getpass
import sys

from sqlalchemy.orm import Session

from app.core.db import SessionLocal
from app.core.security import get_password_hash
from app.models.users import User


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create or promote an admin account in the Townley backend.",
    )
    parser.add_argument("email", help="Email address for the admin user")
    parser.add_argument(
        "--password",
        help="Password for the admin user (omit to be prompted securely)",
    )
    parser.add_argument(
        "--full-name",
        default=None,
        help="Optional full name for the admin user",
    )
    return parser.parse_args(argv)


def ensure_password(password: str | None) -> str:
    if password:
        return password
    first = getpass.getpass("Password: ")
    confirm = getpass.getpass("Confirm password: ")
    if first != confirm:
        raise ValueError("Passwords do not match.")
    if not first:
        raise ValueError("Password may not be empty.")
    return first


def make_admin(db: Session, email: str, password: str, full_name: str | None) -> tuple[User, str]:
    user = db.query(User).filter(User.email == email).first()
    hashed = get_password_hash(password)

    if user:
        user.hashed_password = hashed
        user.full_name = full_name or user.full_name
        user.is_admin = True
        user.role = "admin"
        user.is_active = True
        action = "updated existing user"
    else:
        user = User(
            email=email,
            hashed_password=hashed,
            full_name=full_name,
            is_active=True,
            is_admin=True,
            role="admin",
        )
        db.add(user)
        action = "created new user"

    db.commit()
    db.refresh(user)
    return user, action


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])
    try:
        password = ensure_password(args.password)
    except ValueError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1

    with SessionLocal() as db:
        user, action = make_admin(db, args.email, password, args.full_name)

    print(f"{action}: {user.email} (id={user.id}) is now an admin.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
