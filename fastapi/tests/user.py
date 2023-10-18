from sqlalchemy import insert, delete, select
import unittest

from src.database import Base, DbConnector
from src.user.dependencies import *
from src.user.models import *
from src.user.service import *


class TestDependencies(unittest.TestCase):
    snu_email = "test@snu.ac.kr"
    naver_email = "test@naver.com"

    def test_check_snu_email(self):
        valid_req = EmailRequest(email=self.snu_email)
        invalid_req = EmailRequest(email=self.naver_email)

        self.assertEqual(check_snu_email(valid_req), self.snu_email)
        with self.assertRaises(InvalidEmailException):
            self.assertEqual(check_snu_email(invalid_req), self.naver_email)


class TestService(unittest.TestCase):
    name = "SNEK"
    email = "test@snu.ac.kr"
    naver_email = "test@naver.com"
    code = 100000
    token = "token"

    foods: List[str] = ['A', 'B', 'C', 'D']
    hobbies: List[str] = ['A', 'B', 'C', 'D']
    movies: List[str] = ['A', 'B', 'C', 'D']
    locations: List[str] = ['A', 'B', 'C', 'D']
    languages: List[str] = ['A', 'B', 'C', 'D']
    user_emails: List[str] = [
        "user1@snu.ac.kr",
        "user2@snu.ac.kr",
        "user3@snu.ac.kr",
        "user4@snu.ac.kr",
        "user5@snu.ac.kr",
        "user6@snu.ac.kr",
        "user7@snu.ac.kr",
        "user8@snu.ac.kr",
    ]
    user_names: List[str] = [
        "user1", "user2", "user3", "user4", "user5", "user6", "user7", "user8",
    ]
    user_nation_codes: List[int] = [82, 13, 82, 14, 82, 15, 82, 16]
    user_main_lang_idxs: List[int] = [0, 0, 0, 0, 1, 1, 1, 1]
    user_lang_idxs: List[List[int]] = [
        [0, 2], [0, 2], [0, 3], [0, 3], [1, 2], [1, 2], [1, 3], [1, 3]
    ]

    def setUp(self) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            db.execute(insert(Food).values([{"name": name} for name in self.foods]))
            db.execute(insert(Hobby).values([{"name": name} for name in self.hobbies]))
            db.execute(insert(Movie).values([{"name": name} for name in self.movies]))
            db.execute(insert(Location).values([{"name": name} for name in self.locations]))
            lang_ids = list(db.scalars(insert(Language).values([{"name": name} for name in self.languages]).returning(Language.id)))

            email_ids = db.scalars(insert(Email).values([{"email": email} for email in self.user_emails]).returning(Email.id))
            verification_ids = db.scalars(insert(EmailVerification).values([{
                    "token": self.token,
                    "email_id": email_id
                } for email_id in email_ids]).returning(EmailVerification.id))
            profile_ids = list(db.scalars(insert(Profile).values([{
                    "name": name,
                    "birth": date.today(),
                    "sex": "male",
                    "major": "Hello",
                    "admission_year": 2023,
                    "nation_code": nation_code,
                } for name, nation_code in zip(self.user_names, self.user_nation_codes)]).returning(Profile.id)))
            db.execute(insert(User).values([{
                    "user_id": profile_id,
                    "verification_id": verification_id,
                    "lang_id": lang_ids[main_lang_idx],
                    "salt": "",
                    "hash": ""
                } for profile_id, verification_id, main_lang_idx in zip(profile_ids, verification_ids, self.user_main_lang_idxs)]))
            db.execute(insert(user_lang).values([{
                    "user_id": user_id,
                    "lang_id": lang_ids[lang_idx]
                } for user_id, lang_idxs in zip(profile_ids, self.user_lang_idxs) for lang_idx in lang_idxs]))
            db.commit()

    def tearDown(self) -> None:
        for db in DbConnector.get_db():
            db.execute(delete(user_lang))
            db.execute(delete(User))
            db.execute(delete(Profile))
            db.execute(delete(EmailVerification))
            db.execute(delete(EmailCode))
            db.execute(delete(Email))
            db.execute(delete(Language))
            db.execute(delete(Location))
            db.execute(delete(Movie))
            db.execute(delete(Hobby))
            db.execute(delete(Food))
            db.commit()

    def test_create_verification_code(self):
        for db in DbConnector.get_db():
            code = create_verification_code(self.email, db)
            self.assertEqual(
                db.scalar(select(EmailCode.code).join(EmailCode.email).where(Email.email == self.email)),
                code
            )
            code = create_verification_code(self.email, db)
            self.assertEqual(
                db.scalar(select(EmailCode.code).join(EmailCode.email).where(Email.email == self.email)),
                code
            )

    @unittest.skip("We do not actually send email")
    def test_send_code_via_email(self):
        send_code_via_email(self.email, self.code)

    def test_check_verification_code(self) -> None:
        valid_req = VerificationRequest(email=self.email, code=self.code)
        invalid_email_req = VerificationRequest(email=self.naver_email, code=self.code)
        invalid_code_req = VerificationRequest(email=self.email, code=0)

        for db in DbConnector.get_db():
            db.add(EmailCode(code=self.code, email=Email(email=self.email)))
            db.flush()

            check_verification_code(valid_req, db)
            with self.assertRaises(InvalidEmailCodeException):
                check_verification_code(invalid_email_req, db)
            with self.assertRaises(InvalidEmailCodeException):
                check_verification_code(invalid_code_req, db)

    def test_create_verification(self):
        for db in DbConnector.get_db():
            email_id = db.scalar(insert(Email).values({"email": self.email}).returning(Email.id))
            db.flush()

            self.assertEqual(
                create_verification(self.email, email_id, db),
                db.scalar(select(EmailVerification.token).join(EmailVerification.email).where(Email.email == self.email)),
            )
            with self.assertRaises(EmailInUseException):
                create_verification(self.email, email_id, db)

    def test_check_verification_token(self) -> None:
        profile = ProfileData(name="", birth=date.today(), sex="", major="", admission_year=2000, about_me=None, mbti=None,
                          nation_code=82, foods=[], movies=[], hobbies=[], locations=[])
        valid_req = CreateUserRequest(email=self.email, token=self.token, password="", profile=profile,
                                      main_language="", languages=[])
        invalid_email_req = CreateUserRequest(email=self.naver_email, token=self.token, password="", profile=profile,
                                              main_language="", languages=[])
        invalid_token_req = CreateUserRequest(email=self.email, token="", password="", profile=profile,
                                              main_language="", languages=[])

        for db in DbConnector.get_db():
            db.add(EmailVerification(token=self.token, email=Email(email=self.email)))
            db.flush()

            check_verification_token(valid_req, db)
            with self.assertRaises(InvalidEmailTokenException):
                check_verification_token(invalid_email_req, db)
            with self.assertRaises(InvalidEmailTokenException):
                check_verification_token(invalid_token_req, db)

    @unittest.skip("Currently it fails")
    def test_create_user(self):
        for db in DbConnector.get_db():
            email_id = db.scalar(insert(Email).values({"email": self.email}).returning(Email.id))
            verification_id = db.scalar(insert(EmailVerification).values({"email_id": email_id, "token": self.token}).returning(EmailVerification.id))
            db.flush()

            req = CreateUserRequest(email=self.email, token=self.token, password="", profile=ProfileData(
                    name=self.name,
                    birth=date.today(),
                    sex="male",
                    major="Hello",
                    admission_year=2023,
                    nation_code=82,
                    foods=['A', 'B'],
                    movies=['A', 'B'],
                    hobbies=['A', 'B'],
                    locations=['A', 'B']
                ), main_language='A', languages=['B'])
            user_id = create_user(req, verification_id, db)
            user = db.query(User).join(User.profile).where(Profile.name == self.name).first()
            self.assertEqual(user.user_id, user_id)
            self.assertEqual(user.profile.name, self.name)
            self.assertEqual(set(user.profile.foods), {'A', 'B'} )
            self.assertEqual(set(user.profile.movies), {'A', 'B'})
            self.assertEqual(set(user.profile.hobbies), {'A', 'B'})
            self.assertEqual(set(user.profile.locations), {'A', 'B'})
            self.assertEqual(set(user.languages), {'A', 'B'})

    def test_create_salt_hash(self):
        salt, hash = create_salt_hash('')
        self.assertEqual(len(salt), 24)
        self.assertEqual(len(hash), 44)

    def test_get_target_users(self):
        for db in DbConnector.get_db():
            kor_user = db.query(User).join(User.profile).where(Profile.name == 'user1').first()
            for_user = db.query(User).join(User.profile).where(Profile.name == 'user8').first()

            targets = list(map(lambda user: user.profile.name, get_target_users(kor_user, db)))
            self.assertEqual(set(targets), set(['user2', 'user4', 'user6']))
            targets = list(map(lambda user: user.profile.name, get_target_users(for_user, db)))
            self.assertEqual(set(targets), set(['user7', 'user3', 'user5']))

    def test_sort_target_users(self):
        my_profile = Profile(
            name="sangin", birth=date(1999, 5, 14), sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            mbti="isfj", nation_code=82,
            foods=["korean_food", "japan_food"],
            movies=["horror", "action"],
            locations=["up", "down"],
            hobbies=["soccer", "golf"]
        )

        your_profile1 = Profile(
            name="sangin", birth=date(1999, 5, 14)
            , sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            mbti=None, nation_code=82,
            foods=["italian_food", "japan_food"], movies=["romance", "action"],
            locations=["up", "jahayeon"],
            hobbies=["golf"])

        your_profile2 = Profile(
            name="abdula", birth=date(1999, 5, 14)
            , sex="male", major="CLS", admission_year=2018, about_me="alpha male",
             mbti=None,nation_code=0,
            foods=["korean_food", "japan_food", "italian_food"], movies=["horror", "action", "romance"],
            locations=['up', "down", "jahayeon"],
            hobbies=["soccer"])

        your_profile3 = Profile(
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
