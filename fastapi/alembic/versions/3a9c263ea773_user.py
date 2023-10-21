"""user

Revision ID: 3a9c263ea773
Revises: 1bbfdd0318fb
Create Date: 2023-10-21 17:06:13.432583

"""
import sys
sys.path = ['', '..'] + sys.path[1:]

from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa
from src.user.models import *


# revision identifiers, used by Alembic.
revision: str = '3a9c263ea773'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None

def upgrade() -> None:
    # create email_code table
    op.create_table(
        EmailCode.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("code", sa.Integer, nullable=False)
    )
    op.create_foreign_key("email_id_fk", source_table=EmailCode.__tablename__, referent_table=Email.__tablename__,
                          local_cols=["email_id"], remote_cols=["id"], ondelete="CASCADE")

    # create email_verification table
    op.create_table(
        EmailVerification.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("token", sa.String(44), nullable=False),
    )
    op.create_foreign_key("email_id_fd", source_table=EmailVerification.__tablename__, referent_table=Email.__tablename__,
                          local_cols=["email_id"], remote_cols=["id"], ondelete="CASCADE")

    # create email table
    op.create_table(
        Email.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("email", sa.String(31), nullable=True, unique=True),
    )

    # create food table
    op.create_table(
        Food.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("name", sa.String(31), nullable=False, unique=True)
    )

    # create movie table
    op.create_table(
        Movie.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("name", sa.String(63), nullable=False, unique=True)
    )

    # create hobby table
    op.create_table(
        Hobby.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("name", sa.String(31), nullable=False, unique=True)
    )

    # create location table
    op.create_table(
        Location.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("name", sa.String(31), nullable=False, unique=True)
    )

    # create language table
    op.create_table(
        Language.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("name", sa.String(31), nullable=False, unique=True)
    )

def downgrade() -> None:
    op.drop_table(EmailCode.__tablename__)
    op.drop_table(EmailVerification.__tablename__)
    op.drop_table(Email.__tablename__)
    op.drop_table(Food.__tablename__)
    op.drop_table(Movie.__tablename__)
    op.drop_table(Hobby.__tablename__)
    op.drop_table(Location.__tablename__)
    op.drop_table(Language.__tablename__)
