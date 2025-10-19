from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = '20250820_0001_init'
down_revision = None
branch_labels = None
depends_on = None

def upgrade() -> None:
    # Users table
    op.create_table(
        'Users',
        sa.Column('id', sa.Integer(), primary_key=True, autoincrement=True),
        sa.Column('email', sa.String(length=255), nullable=False, unique=True),
        sa.Column('hashed_password', sa.String(length=255), nullable=False),
        sa.Column('full_name', sa.String(length=255), nullable=True),
        sa.Column('is_active', sa.Boolean(), server_default=sa.text('1'), nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now(), nullable=False),
    )
    op.create_index('ix_users_email', 'Users', ['email'], unique=True)

    # WorkOrders table (if not exists)
    op.create_table(
        'WorkOrders',
        sa.Column('RecordNo', sa.Integer(), primary_key=True, autoincrement=True),
        sa.Column('WorkOrderNo', sa.String(length=100), nullable=False),
        sa.Column('PartNo', sa.String(length=100), nullable=False),
        sa.Column('CustomerName', sa.String(length=200), nullable=True),
        sa.Column('AlloyCode', sa.String(length=100), nullable=True),
        sa.Column('QtyRequired', sa.Integer(), nullable=False),
        sa.Column('RushDueDate', sa.Date(), nullable=True),
        sa.Column('SerialNo', sa.String(length=100), nullable=True),
        sa.Column('StatusNotes', sa.String(length=255), nullable=True),
        sa.Column('MoldingFinished', sa.Boolean(), nullable=True),
        sa.Column('PouringFinished', sa.Boolean(), nullable=True),
        sa.Column('HeatTreatFinished', sa.Boolean(), nullable=True),
        sa.Column('MachiningFinished', sa.Boolean(), nullable=True),
        sa.Column('AssemblyFinished', sa.Boolean(), nullable=True),
        sa.Column('FinalInspComp', sa.Boolean(), nullable=True),
        sa.Column('Status', sa.String(length=50), nullable=True),
    )

def downgrade() -> None:
    op.drop_table('WorkOrders')
    op.drop_index('ix_users_email', table_name='Users')
    op.drop_table('Users')
