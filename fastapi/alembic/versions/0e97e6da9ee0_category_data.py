"""category_data

Revision ID: 0e97e6da9ee0
Revises: 4298926078ea
Create Date: 2023-10-22 17:38:21.014599

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = '0e97e6da9ee0'
down_revision: Union[str, None] = '4298926078ea'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
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


def downgrade() -> None:
    pass