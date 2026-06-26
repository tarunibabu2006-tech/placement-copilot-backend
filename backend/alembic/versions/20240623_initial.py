"""Create users table migration

Revision ID: 20240623_initial
Revises: 
Create Date: 2024-06-23
"""

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "20240623_initial"
down_revision = None
branch_labels = None
depends_on = None

def upgrade():
    op.create_table(
        "users",
        sa.Column("id", sa.Integer, primary_key=True, index=True),
        sa.Column("email", sa.String, unique=True, nullable=False, index=True),
        sa.Column("hashed_password", sa.String, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
    )

def downgrade():
    op.drop_table("users")
