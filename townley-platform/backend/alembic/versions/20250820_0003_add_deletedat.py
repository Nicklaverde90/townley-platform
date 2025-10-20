from alembic import op  # type: ignore[attr-defined]
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "20250820_0003_add_deletedat"
down_revision = "20250820_0002_add_is_admin"
branch_labels = None
depends_on = None


def upgrade():
    op.add_column("WorkOrders", sa.Column("DeletedAt", sa.DateTime(), nullable=True))


def downgrade():
    op.drop_column("WorkOrders", "DeletedAt")
