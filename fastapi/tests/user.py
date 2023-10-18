from sqlalchemy import insert, delete, select
import unittest

from src.database import Base, DbConnector
from src.user.dependencies import *
from src.user.models import *
from src.user.schemas import ProfileData
from src.user.service import *


class TestDependencies(unittest.TestCase):
    snu_email = "test@snu.ac.kr"
    naver_email = "test@naver.com"
    code = 100000
    token = "token"

    def setUp(self) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            email_id = db.scalar(insert(Email).values({"email": self.snu_email}).returning(Email.id))
            db.execute(insert(EmailCode).values({
                "code": self.code,
                "email_id": email_id
            }))
            db.execute(insert(EmailVerification).values({
                "token": self.token,
                "email_id": email_id
            }))
            db.commit()

    def tearDown(self) -> None:
        for db in DbConnector.get_db():
            db.execute(delete(EmailVerification))
            db.execute(delete(EmailCode))
            db.execute(delete(Email))
            db.commit()

    def test_check_snu_email(self):
        valid_req = EmailRequest(email=self.snu_email)
        invalid_req = EmailRequest(email=self.naver_email)

        self.assertEqual(check_snu_email(valid_req), self.snu_email)
        with self.assertRaises(InvalidEmailException):
            self.assertEqual(check_snu_email(invalid_req), self.naver_email)

    def test_check_verification_code(self) -> None:
        valid_req = VerificationRequest(email=self.snu_email, code=self.code)
        invalid_email_req = VerificationRequest(email=self.naver_email, code=self.code)
        invalid_code_req = VerificationRequest(email=self.snu_email, code=0)

        for db in DbConnector.get_db():
            self.assertEqual(check_verification_code(valid_req, db), self.snu_email)
            with self.assertRaises(InvalidEmailException):
                self.assertEqual(check_verification_code(invalid_email_req, db), self.naver_email)
            with self.assertRaises(InvalidEmailCodeException):
                self.assertEqual(check_verification_code(invalid_code_req, db), self.snu_email)

    def test_check_verification_token(self) -> None:
        profile = ProfileData(name="", birth=date.today(), sex="", major="", admission_year=2000, about_me=None, mbti=None,
                          nation_code=82, foods=[], movies=[], hobbies=[], locations=[])
        valid_req = CreateUserRequest(email=self.snu_email, token=self.token, password="", profile=profile,
                                      main_language="", languages=[])
        invalid_email_req = CreateUserRequest(email=self.naver_email, token=self.token, password="", profile=profile,
                                              main_language="", languages=[])
        invalid_token_req = CreateUserRequest(email=self.snu_email, token="", password="", profile=profile,
                                              main_language="", languages=[])

        for db in DbConnector.get_db():
            check_verification_token(valid_req, db)
            with self.assertRaises(InvalidEmailException):
                check_verification_token(invalid_email_req, db)
            with self.assertRaises(InvalidEmailTokenException):
                check_verification_token(invalid_token_req, db)


class TestService(unittest.TestCase):
    email = "test@snu.ac.kr"
    code = 100000

    def setUp(self) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)

    def tearDown(self) -> None:
        for db in DbConnector.get_db():
            db.execute(delete(EmailCode))
            db.execute(delete(Email))
            db.commit()

    def test_create_verification_code(self):
        for db in DbConnector.get_db():
            self.assertEqual(
                create_verification_code(self.email, db),
                db.scalar(select(EmailCode.code).join(EmailCode.email).where(Email.email == self.email)),
            )
    
    @unittest.skip("We do not actually send email")
    def test_send_code_via_email(self):
        send_code_via_email(self.email, self.code)

    def test_sort_target_users(self):
        my_profile = ProfileData(
            name="sangin", birth=date(1999, 5, 14), sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            mbti="isfj", nation_code=82,
            foods=["korean_food", "japan_food"],
            movies=["horror", "action"],
            locations=["up", "down"],
            hobbies=["soccer", "golf"]
        )

        your_profile1 = ProfileData(
            name="sangin", birth=date(1999, 5, 14)
            , sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            mbti=None, nation_code=82,
            foods=["italian_food", "japan_food"], movies=["romance", "action"],
            locations=["up", "jahayeon"],
            hobbies=["golf"])

        your_profile2 = ProfileData(
            name="abdula", birth=date(1999, 5, 14)
            , sex="male", major="CLS", admission_year=2018, about_me="alpha male",
             mbti=None,nation_code=0,
            foods=["korean_food", "japan_food", "italian_food"], movies=["horror", "action", "romance"],
            locations=['up', "down", "jahayeon"],
            hobbies=["soccer"])

        your_profile3 = ProfileData(
            name="jiho", birth=date(1999, 5, 14)
            , sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            nation_code=1, mbti=None,
            foods=["japan_food"], movies=["action"],
            locations=["jahayeon"],
            hobbies=["golf", "soccer", "book"])

        me = User(user_id = 0, verification_id=1, lang_id=1, salt="1", hash="1", profile=my_profile)
        you1 = User(user_id = 1, verification_id=2, lang_id=2, salt="2", hash="2", profile=your_profile1)
        you2 = User(user_id = 2, verification_id=3, lang_id=3, salt="3", hash="3", profile=your_profile2)
        you3 = User(user_id = 3, verification_id=4, lang_id=4, salt="4", hash="4", profile=your_profile3)
        yous = [you1, you2, you3]

        result = sort_target_users(me, yous)
        self.assertEqual(result[0].user_id, 2)
        self.assertEqual(result[0].profile.name, "abdula")
        self.assertEqual(result[1].user_id, 1)
        self.assertEqual(result[1].profile.name, "sangin")
        self.assertEqual(result[2].user_id, 3)
        self.assertEqual(result[2].profile.name, "jiho")

if __name__ == '__main__':
    unittest.main()
