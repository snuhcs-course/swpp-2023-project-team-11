from sqlalchemy import Integer, String, Column, create_engine
import unittest

from src.database import Base, DbConnector


class ForTest(Base):
    __tablename__ = "test_table"

    id = Column(Integer, primary_key=True)
    subject = Column(String, nullable=False)


class TestDbConnector(unittest.TestCase):

    def test_connection(self):
        Base.metadata.create_all(bind=DbConnector.engine)
        db = DbConnector.get_db()

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
