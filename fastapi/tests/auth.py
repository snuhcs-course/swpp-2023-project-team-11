from sqlalchemy import insert
import unittest

from src.auth.dependencies import *
from src.auth.service import *
from src.database import Base, DbConnector
from src.user.models import Language, Profile
from tests.utils import *


class TestDependencies(unittest.TestCase):
    snu_email = "test@snu.ac.kr"
    naver_email = "test@naver.com"
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
    def tearDownClass(cls) -> None:
        for db in DbConnector.get_db():
            teardown_user(db)
            db.commit()

    def test_check_password(self):
        valid_req = OAuth2PasswordRequestForm(username=self.snu_email, password=self.password)
        invalid_email_req = OAuth2PasswordRequestForm(username=self.naver_email, password=self.password)
        invalid_password_req = OAuth2PasswordRequestForm(username=self.snu_email, password="")

        for db in DbConnector.get_db():
            check_password(valid_req, db)
            with self.assertRaises(InvalidUserException):
                check_password(invalid_email_req, db)
            with self.assertRaises(InvalidPasswordException):
                check_password(invalid_password_req, db)

    def test_get_session(self):
        for db in DbConnector.get_db():
            self.assertEqual(get_session(self.session_key, db).user.profile.id, self.profile_id)
            with self.assertRaises(InvalidSessionException):
                get_session("", db)


class TestService(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            cls.profile_id = setup_user(db, "")
            db.commit()

    @classmethod
    def tearDownClass(cls) -> None:
        for db in DbConnector.get_db():
            teardown_user(db)
            db.commit()

    def test_create_delete_session(self):
        for db in DbConnector.get_db():
            session_key = create_session(self.profile_id, db)
            with self.assertRaises(IntegrityError):
                db.execute(insert(Session).values({"session_key": session_key, "user_id": self.profile_id}))
            db.commit()
            delete_session(session_key, db)
            with self.assertRaises(InvalidSessionException):
                delete_session(session_key, db)
            with self.assertRaises(InvalidSessionException):
                delete_session("", db)
            db.commit()

if __name__ == '__main__':
    unittest.main()
