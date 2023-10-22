"""auth

Revision ID: 4616a5d787b1
Revises: 3a9c263ea773
Create Date: 2023-10-21 17:38:00.028255

"""

from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa
from src.auth.models import *

# revision identifiers, used by Alembic.
revision: str = '4616a5d787b1'
down_revision: Union[str, None] = '3a9c263ea773'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        Session.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("session_key", sa.String(44), nullable=False, unique=True),
        sa.Column("user_id", sa.Integer, nullable=False)
    )
    op.create_foreign_key("user_id_fk", source_table=Session.__tablename__, referent_table=User.__tablename__,
                          local_cols=["user_id"], remote_cols=["user_id"], ondelete="CASCADE")


def downgrade() -> None:
    op.drop_table("session")