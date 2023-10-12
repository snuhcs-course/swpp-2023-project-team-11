import os
from sqlalchemy import Engine, Integer, String, Column, create_engine
from sqlalchemy.orm import sessionmaker, Session
import unittest

from src.database import Base, declarative_session


class ForTest(Base):
    __tablename__ = "test_table"

    id = Column(Integer, primary_key=True)
    subject = Column(String, nullable=False)


class TestDbConnector(unittest.TestCase):
    PG_DB = os.environ.get('SNEK_POSTGRES_DB')
    PG_USER = os.environ.get('SNEK_POSTGRES_USER')
    PG_PW = os.environ.get('SNEK_POSTGRES_PW')
    TEST_DB_URL: str = f"postgresql://{PG_USER}:{PG_PW}@localhost:5432/{PG_DB}"
    engine: Engine = create_engine(TEST_DB_URL)
    SessionLocal: sessionmaker[Session] = declarative_session(engine)

    def test_connection(self):
        Base.metadata.create_all(bind=self.engine)
        db = self.SessionLocal()

        test = ForTest(id=1, subject="math")

        db.add(test)
        db.commit()

        test = db.query(ForTest).first()
        self.assertEqual(test.id, 1)
        self.assertEqual(test.subject, "math")

        db.delete(test)
        db.commit()


if __name__ == "__main__":
    unittest.main()
