from datetime import date
from sqlalchemy import insert, delete
import unittest

from src.auth.dependencies import *
from src.auth.service import *
from src.database import Base, DbConnector
from src.user.models import Language, Profile, Country


class TestDependencies(unittest.TestCase):
    snu_email = "test@snu.ac.kr"
    naver_email = "test@naver.com"
    token = "token"
    password = "password"
    salt = "salt"
    hash = "TgnJJnmbbfKJLmZiArqCc61kGYrZlvlfsatsFfKlQK4="
    session_key = "session_key"
    name = "SNEK"

    def setUp(self) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            email_id = db.scalar(insert(Email).values({"email": self.snu_email}).returning(Email.id))
            verification_id = db.scalar(
                insert(EmailVerification).values({
                    "token": self.token,
                    "email_id": email_id,
                })
                .returning(EmailVerification.id)
            )
            country_id = db.scalar(insert(Country).values({"name": "Korea"}).returning(Country.id))
            lang_id = db.scalar(insert(Language).values({"name": "Korean"}).returning(Language.id))
            profile_id = db.scalar(
                insert(Profile).values({
                    "name": self.name,
                    "birth": date.today(),
                    "sex": "",
                    "major": "",
                    "admission_year": 2023,
                    "country_id": country_id,
                })
                .returning(Profile.id)
            )
            db.execute(insert(User).values({
                "salt": self.salt,
                "hash": self.hash,
                "user_id": profile_id,
                "verification_id": verification_id,
                "lang_id": lang_id,
            }))
            db.execute(insert(Session).values({
                "session_key": self.session_key,
                "user_id": profile_id,
            }))
            db.commit()
    
    def tearDown(self) -> None:
        for db in DbConnector.get_db():
            db.execute(delete(Session))
            db.execute(delete(User))
            db.execute(delete(Profile))
            db.execute(delete(Language))
            db.execute(delete(Country))
            db.execute(delete(EmailVerification))
            db.execute(delete(Email))
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
            self.assertEqual(get_session(self.session_key, db).user.profile.name, self.name)
            with self.assertRaises(InvalidSessionException):
                get_session("", db)


class TestService(unittest.TestCase):
    email = "test@snu.ac.kr"
    token = "token"
    password = "password"
    salt = "salt"
    hash = "TgnJJnmbbfKJLmZiArqCc61kGYrZlvlfsatsFfKlQK4="
    name = "SNEK"

    def setUp(self) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            email_id = db.scalar(insert(Email).values({"email": self.email}).returning(Email.id))
            verification_id = db.scalar(
                insert(EmailVerification).values({
                    "token": self.token,
                    "email_id": email_id,
                })
                .returning(EmailVerification.id)
            )
            country_id = db.scalar(insert(Country).values({"name": "Korea"}).returning(Country.id))
            lang_id = db.scalar(insert(Language).values({"name": "Korean"}).returning(Language.id))
            self.profile_id = db.scalar(
                insert(Profile).values({
                    "name": self.name,
                    "birth": date.today(),
                    "sex": "",
                    "major": "",
                    "admission_year": 2023,
                    "country_id": country_id,
                })
                .returning(Profile.id)
            )
            db.execute(insert(User).values({
                "salt": self.salt,
                "hash": self.hash,
                "user_id": self.profile_id,
                "verification_id": verification_id,
                "lang_id": lang_id,
            }))
            db.commit()

    def tearDown(self) -> None:
        for db in DbConnector.get_db():
            db.execute(delete(Session))
            db.execute(delete(User))
            db.execute(delete(Profile))
            db.execute(delete(Language))
            db.execute(delete(Country))
            db.execute(delete(EmailVerification))
            db.execute(delete(Email))
            db.commit()

    def test_create_delete_session(self):
        for db in DbConnector.get_db():
            session_key = create_session(self.profile_id, db)
            with self.assertRaises(InvalidSessionException):
                delete_session("", db)
            delete_session(session_key, db)

if __name__ == '__main__':
    unittest.main()
