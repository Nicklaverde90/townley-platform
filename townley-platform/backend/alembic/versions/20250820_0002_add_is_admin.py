"""add is_admin column to Users"""

from alembic import op  # type: ignore[attr-defined]
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "20250820_0002_add_is_admin"
down_revision = "20250820_0001_init"
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table("Users") as batch_op:
        try:
            batch_op.add_column(
                sa.Column(
                    "is_admin", sa.Boolean(), nullable=False, server_default=sa.false()
                )
            )
        except Exception:
            # Column may already exist; ignore.
            pass


def downgrade():
    with op.batch_alter_table("Users") as batch_op:
        try:
            batch_op.drop_column("is_admin")
        except Exception:
            pass
