"""create workorder audit table"""

from alembic import op  # type: ignore[attr-defined]
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "20250820_0004_workorder_audit"
down_revision = "20250820_0003_add_deletedat"
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "WorkOrderAudit",
        sa.Column("Id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("Action", sa.String(32), nullable=False),
        sa.Column("RecordNo", sa.Integer, nullable=False),
        sa.Column("BeforeJson", sa.Text, nullable=True),
        sa.Column("AfterJson", sa.Text, nullable=True),
        sa.Column("UserEmail", sa.String(255), nullable=True),
        sa.Column(
            "AtUtc",
            sa.DateTime(timezone=False),
            nullable=False,
            server_default=sa.func.now(),
        ),
    )


def downgrade():
    op.drop_table("WorkOrderAudit")
