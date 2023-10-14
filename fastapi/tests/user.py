import os
from sqlalchemy import Engine, create_engine
from sqlalchemy.orm import sessionmaker, Session
import unittest

from src.database import Base, declarative_session
from src.user.models import *


class MyTestCase(unittest.TestCase):
    PG_DB = os.environ.get('SNEK_POSTGRES_DB')
    PG_USER = os.environ.get('SNEK_POSTGRES_USER')
    PG_PW = os.environ.get('SNEK_POSTGRES_PW')
    TEST_DB_URL: str = f"postgresql://{PG_USER}:{PG_PW}@localhost:5432/{PG_DB}"

    engine: Engine = create_engine(TEST_DB_URL)
    SessionLocal: sessionmaker[Session] = declarative_session(engine)

    def test_create_tables(self):
        Base.metadata.create_all(bind=self.engine)
        db = self.SessionLocal()

        self.assertEqual(db.query(Food).count(), 0)
        self.assertEqual(db.query(Country).count(), 0)


if __name__ == '__main__':
    unittest.main()
