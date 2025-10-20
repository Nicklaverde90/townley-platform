"""add role to users

Revision ID: 20250820_0005
Revises: 20250820_0004_workorder_audit
Create Date: 2025-08-20 21:55:00

"""

from alembic import op  # type: ignore[attr-defined]
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "20250820_0005_add_role_to_users"
down_revision = "20250820_0004_workorder_audit"
branch_labels = None
depends_on = None


def upgrade():
    op.add_column(
        "Users",
        sa.Column(
            "role", sa.String(length=16), nullable=False, server_default="viewer"
        ),
    )


def downgrade():
    op.drop_column("Users", "role")
