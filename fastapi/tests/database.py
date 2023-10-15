import os
from sqlalchemy import Engine, Integer, String, Column, create_engine
from sqlalchemy.orm import sessionmaker, Session
import unittest

from src.database import Base, engine, SessionLocal


class ForTest(Base):
    __tablename__ = "test_table"

    id = Column(Integer, primary_key=True)
    subject = Column(String, nullable=False)


class TestDbConnector(unittest.TestCase):

    def test_connection(self):
        Base.metadata.create_all(bind=self.engine)
        db = SessionLocal()

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
