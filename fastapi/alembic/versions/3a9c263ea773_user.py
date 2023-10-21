"""user

Revision ID: 3a9c263ea773
Revises:
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
    # create profile table
    op.create_table(Profile.__tablename__,
                    sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
                    sa.Column('name', sa.String[31], nullable=False),
                    sa.Column('birth', sa.Date, nullable=False),
                    sa.Column('sex', sa.String[15], nullable=False),
                    sa.Column('major', sa.String[31], nullable=False),
                    sa.Column('admission_year', sa.Integer, nullable=False),
                    sa.Column('about_me', sa.String[255]),
                    sa.Column('mbti', sa.String[15]),
                    sa.Column('nation_code', sa.Integer, nullable=False)
                    )
    # create users table
    op.create_table(User.__tablename__,

                    sa.Column('user_id', sa.Integer, primary_key=True),
                    sa.Column('verification_id', sa.Integer, nullable=False, unique=True),
                    sa.Column('lang_id', sa.Integer, nullable=False),
                    sa.Column('salt', sa.String[24], nullable=False),
                    sa.Column('hash', sa.String[44], nullable=False)
                    )
    # create email_code table

    op.create_table(
        EmailCode.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("email_id", sa.Integer, nullable=False,unique=True),
        sa.Column("code", sa.Integer, nullable=False)
    )

    # create email_verification table
    op.create_table(
        EmailVerification.__tablename__,
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("email_id", sa.Integer, nullable=False, unique=True),
        sa.Column("token", sa.String(44), nullable=False),
    )

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
    op.create_foreign_key("email_id_fk", source_table=EmailCode.__tablename__, referent_table=Email.__tablename__,
                          local_cols=["email_id"], remote_cols=["id"], ondelete="CASCADE")
    op.create_foreign_key("user_id_fk", source_table=User.__tablename__, referent_table=Profile.__tablename__,
                          local_cols=["user_id"], remote_cols=["id"])
    op.create_foreign_key('lang_id_fk', source_table="users", referent_table=Language.__tablename__,
                          local_cols=["lang_id"], remote_cols=["id"])
    op.create_foreign_key("email_id_fd", source_table=EmailVerification.__tablename__,
                          referent_table=Email.__tablename__,
                          local_cols=["email_id"], remote_cols=["id"], ondelete="CASCADE")


def downgrade() -> None:
    op.drop_table(EmailCode.__tablename__)
    op.drop_table(EmailVerification.__tablename__)
    op.drop_table(Email.__tablename__)
    op.drop_table(Food.__tablename__)
    op.drop_table(Movie.__tablename__)
    op.drop_table(Hobby.__tablename__)
    op.drop_table(Location.__tablename__)
    op.drop_table(Language.__tablename__)
    op.drop_table(User.__tablename__)
    op.drop_table(Profile.__tablename__)
