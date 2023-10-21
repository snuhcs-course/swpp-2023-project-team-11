"""user

Revision ID: 3a9c263ea773
Revises: 1bbfdd0318fb
Create Date: 2023-10-21 17:06:13.432583

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '3a9c263ea773'
down_revision: Union[str, None] = '1bbfdd0318fb'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
