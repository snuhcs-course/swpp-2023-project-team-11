from sqlalchemy import insert
import unittest

from src.auth.dependencies import *
from src.auth.service import *
from src.database import Base, DbConnector
from tests.utils import *


class TestDependencies(unittest.TestCase):
    snu_email = "test@snu.ac.kr"
    password = "password"
    session_key = "session_key"

    @classmethod
    def setUpClass(cls) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            cls.profile_id = setup_user(db, cls.snu_email)
            db.execute(insert(Session).values({
                "session_key": cls.session_key,
                "user_id": cls.profile_id,
            }))
            db.commit()

    @classmethod
    @inject_db
    def tearDownClass(cls, db: DbSession) -> None:
        teardown_user(db)
        db.commit()

    @inject_db
    def test_check_password(self, db: DbSession):
        valid_req = OAuth2PasswordRequestForm(
            username=self.snu_email, password=self.password)
        invalid_password_req = OAuth2PasswordRequestForm(
            username=self.snu_email, password="")

        check_password(valid_req, db)
        with self.assertRaises(InvalidPasswordException):
            check_password(invalid_password_req, db)

    @inject_db
    def test_get_session(self, db: DbSession):
        self.assertEqual(check_session(self.session_key, db), self.profile_id)
        with self.assertRaises(InvalidSessionException):
            check_session("", db)


class TestService(unittest.TestCase):
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
    def test_create_session(self, db: DbSession):
        session_key = create_session(self.profile_id, db)
        with self.assertRaises(IntegrityError):
            db.execute(insert(Session).values(
                {"session_key": session_key, "user_id": self.profile_id}))

    @inject_db
    def test_delete_session(self, db: DbSession):
        session_key = create_session(self.profile_id, db)
        delete_session(session_key, db)
        with self.assertRaises(InvalidSessionException):
            delete_session(session_key, db)
        with self.assertRaises(InvalidSessionException):
            delete_session("", db)


if __name__ == '__main__':
    unittest.main()
