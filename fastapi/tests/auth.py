from sqlalchemy import insert
import unittest
from unittest.mock import patch, MagicMock, Mock

from src.auth.dependencies import *
from src.auth.service import *
from src.database import Base, DbConnector
from tests.utils import *


class TestDependencies(unittest.TestCase):
    email = "test@snu.ac.kr"
    password = "password"
    session_key = "session_key"
    salt = "salt"
    hash = "TgnJJnmbbfKJLmZiArqCc61kGYrZlvlfsatsFfKlQK4="

    @patch('src.auth.dependencies.get_user_by_email')
    @InjectMock("db")
    def test_check_password(self, mock_get_user_by_email: MagicMock, db: DbSession):
        dummy_user = Mock()
        dummy_user.salt = self.salt
        dummy_user.hash = self.hash
        mock_get_user_by_email.side_effect = lambda db, email: dummy_user

        valid_req = OAuth2PasswordRequestForm(
            username=self.email, password=self.password)
        invalid_password_req = OAuth2PasswordRequestForm(
            username=self.email, password="")

        check_password(valid_req, db)
        with self.assertRaises(InvalidPasswordException):
            check_password(invalid_password_req, db)

    @patch('src.auth.service.get_session_by_key')
    @InjectMock("db")
    def test_check_session(self, mock_get_session_by_key: MagicMock, db: DbSession):
        dummy_session = Mock()
        dummy_session.user_id = 1
        mock_get_session_by_key.side_effect = lambda db, session_key: dummy_session

        self.assertEqual(check_session(self.session_key, db),
                         dummy_session.user_id)


class TestDb(unittest.TestCase):
    session_key = "session-key"

    @classmethod
    def setUpClass(cls) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            cls.profile_id = setup_user(db, "")
            db.commit()

    @classmethod
    @inject_db
    def tearDownClass(cls, db: DbSession) -> None:
        teardown_user(db)
        db.commit()

    @inject_db
    def get_session_by_key(self, db: DbSession):
        db.execute(insert(Session).values({
            "session_key": self.session_key,
            "user_id": self.profile_id,
        }))

        self.assertEqual(get_session_by_key(
            db, self.session_key).user_id, self.profile_id)
        with self.assertRaises(InvalidSessionException):
            get_session_by_key(db, "")

    @inject_db
    def test_create_session(self, db: DbSession):
        create_session(db, self.session_key, self.profile_id)
        with self.assertRaises(InternalServerError):
            create_session(db, self.session_key, self.profile_id)

    @inject_db
    def test_delete_session(self, db: DbSession):
        create_session(db, self.session_key, self.profile_id)
        delete_session(db, self.session_key)
        with self.assertRaises(InvalidSessionException):
            delete_session(db, self.session_key)
        with self.assertRaises(InvalidSessionException):
            delete_session(db, "")


if __name__ == '__main__':
    unittest.main()
