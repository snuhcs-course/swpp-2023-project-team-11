import unittest

from src.auth.models import *
from src.user.models import *
from src.database import Base, DbConnector


class TestDbConnector(unittest.TestCase):
    def test_connection(self):
        Base.metadata.create_all(bind=DbConnector.engine)


if __name__ == "__main__":
    unittest.main()
