"""user

Revision ID: 2c1168cf3d1c
Revises: 
Create Date: 2023-10-22 16:34:22.117255

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '2c1168cf3d1c'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    email = op.create_table('email',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('email', sa.String(length=31), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('email')
    )
    op.create_table('food',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(length=31), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('name')
    )
    op.create_table('hobby',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(length=31), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('name')
    )
    op.create_table('language',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(length=31), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('name')
    )
    op.create_table('location',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(length=31), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('name')
    )
    op.create_table('movie',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(length=63), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('name')
    )
    op.create_table('profile',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('name', sa.String(length=31), nullable=False),
    sa.Column('birth', sa.Date(), nullable=False),
    sa.Column('sex', sa.String(length=15), nullable=False),
    sa.Column('major', sa.String(length=31), nullable=False),
    sa.Column('admission_year', sa.Integer(), nullable=False),
    sa.Column('about_me', sa.String(length=255), nullable=True),
    sa.Column('mbti', sa.String(length=15), nullable=True),
    sa.Column('nation_code', sa.Integer(), nullable=False),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('email_code',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('email_id', sa.Integer(), nullable=False),
    sa.Column('code', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['email_id'], ['email.id'], ondelete='CASCADE'),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('email_id')
    )
    op.create_table('email_verification',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('email_id', sa.Integer(), nullable=False),
    sa.Column('token', sa.String(length=44), nullable=False),
    sa.ForeignKeyConstraint(['email_id'], ['email.id'], ondelete='CASCADE'),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('email_id')
    )
    op.create_table('user_food',
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('food_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['food_id'], ['food.id'], ondelete='CASCADE'),
    sa.ForeignKeyConstraint(['user_id'], ['profile.id'], ondelete='CASCADE')
    )
    op.create_table('user_hobby',
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('hobby_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['hobby_id'], ['hobby.id'], ondelete='CASCADE'),
    sa.ForeignKeyConstraint(['user_id'], ['profile.id'], ondelete='CASCADE')
    )
    op.create_table('user_location',
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('location_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['location_id'], ['location.id'], ondelete='CASCADE'),
    sa.ForeignKeyConstraint(['user_id'], ['profile.id'], ondelete='CASCADE')
    )
    op.create_table('user_movie',
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('movie_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['movie_id'], ['movie.id'], ondelete='CASCADE'),
    sa.ForeignKeyConstraint(['user_id'], ['profile.id'], ondelete='CASCADE')
    )
    op.create_table('users',
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('verification_id', sa.Integer(), nullable=False),
    sa.Column('lang_id', sa.Integer(), nullable=False),
    sa.Column('salt', sa.String(length=24), nullable=False),
    sa.Column('hash', sa.String(length=44), nullable=False),
    sa.ForeignKeyConstraint(['lang_id'], ['language.id'], ),
    sa.ForeignKeyConstraint(['user_id'], ['profile.id'], ),
    sa.ForeignKeyConstraint(['verification_id'], ['email_verification.id'], ),
    sa.PrimaryKeyConstraint('user_id'),
    sa.UniqueConstraint('verification_id')
    )
    op.create_table('user_lang',
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('lang_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['lang_id'], ['language.id'], ondelete='CASCADE'),
    sa.ForeignKeyConstraint(['user_id'], ['users.user_id'], ondelete='CASCADE')
    )

    # Insert emails for integration test
    op.bulk_insert(email, [{'email': 'integration1@snu.ac.kr'}, {'email': 'integration2@snu.ac.kr'}])
    op.execute("insert into email_verification (email_id, token) select id, 'token' from email")

    # Insert category data(lang, food, hobby, location, movie)
    meta = sa.MetaData()
    meta.reflect(only=('language', 'food', 'hobby', 'location', 'movie'), bind=op.get_bind())

    language_data = [{'name': 'english'},
                     {'name': 'spanish'},
                     {'name': 'chinese'},
                     {'name': 'arabic'},
                     {'name': 'french'},
                     {'name': 'german'},
                     {'name': 'japanese'},
                     {'name': 'russian'},
                     {'name': 'portuguese'},
                     {'name': 'korean'},
                     {'name': 'italian'},
                     {'name': 'dutch'},
                     {'name': 'swedish'},
                     {'name': 'turkish'},
                     {'name': 'hebrew'},
                     {'name': 'hindi'},
                     {'name': 'thai'},
                     {'name': 'greek'},
                     {'name': 'vietnamese'},
                     {'name': 'finnish'},
                     ]
    food_data = [{'name': 'korean'}, {'name': 'spanish'}, {'name': 'american'},
                 {'name': 'italian'}, {'name': 'thai'}, {'name': 'chinese'},
                 {'name': 'japanese'}, {'name': 'indian'}, {'name': 'mexican'},
                 {'name': 'vegan'}, {'name': 'dessert'}]
    hobby_data = [
        {'name': 'painting'},
        {'name': 'gardening'},
        {'name': 'hiking'},
        {'name': 'reading'},
        {'name': 'cooking'},
        {'name': 'photography'},
        {'name': 'dancing'},
        {'name': 'swimming'},
        {'name': 'cycling'},
        {'name': 'traveling'},
        {'name': 'gaming'},
        {'name': 'fishing'},
        {'name': 'knitting'},
        {'name': 'music'},
        {'name': 'yoga'},
        {'name': 'writing'},
        {'name': 'shopping'},
        {'name': 'teamSports'},
        {'name': 'fitness'},
        {'name': 'movie'}
    ]
    movie_data = [
        {'name': 'action'},
        {'name': 'adventure'},
        {'name': 'animation'},
        {'name': 'comedy'},
        {'name': 'drama'},
        {'name': 'fantasy'},
        {'name': 'horror'},
        {'name': 'mystery'},
        {'name': 'romance'},
        {'name': 'scienceFiction'},
        {'name': 'thriller'},
        {'name': 'western'}
    ]
    location_data = [
        {'name': 'humanity'},
        {'name': 'naturalScience'},
        {'name': 'dormitory'},
        {'name': 'socialScience'},
        {'name': 'humanEcology'},
        {'name': 'agriculture'},
        {'name': 'highEngineering'},
        {'name': 'lowEngineering'},
        {'name': 'business'},
        {'name': 'jahayeon'},
        {'name': 'studentUnion'},
        {'name': 'seolYeep'},
        {'name': 'nockDoo'},
        {'name': 'bongcheon'}
    ]
    language_table = sa.Table('language', meta)
    op.bulk_insert(language_table, language_data)
    food_table = sa.Table('food', meta)
    op.bulk_insert(food_table, food_data)
    hobby_table = sa.Table('hobby', meta)
    op.bulk_insert(hobby_table, hobby_data)
    movie_table = sa.Table('movie', meta)
    op.bulk_insert(movie_table, movie_data)
    location_table = sa.Table('location', meta)
    op.bulk_insert(location_table, location_data)


# ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('user_lang')
    op.drop_table('users')
    op.drop_table('user_movie')
    op.drop_table('user_location')
    op.drop_table('user_hobby')
    op.drop_table('user_food')
    op.drop_table('email_verification')
    op.drop_table('email_code')
    op.drop_table('profile')
    op.drop_table('movie')
    op.drop_table('location')
    op.drop_table('language')
    op.drop_table('hobby')
    op.drop_table('food')
    op.drop_table('email')
    # ### end Alembic commands ###
