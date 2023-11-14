import pandas as pd
from sqlalchemy import insert, delete, select
import unittest

from src.database import Base, DbConnector
from src.user.dependencies import *
from src.user.models import *
from src.user.service import *
from tests.utils import *

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
    user_nation_codes: List[int] = [KOREA_CODE, 13, KOREA_CODE, 14, KOREA_CODE, 15, KOREA_CODE, 16]
    user_main_lang_idxs: List[int] = [0, 0, 0, 0, 1, 1, 1, 1]
    user_lang_idxs: List[List[int]] = [
        [0, 2], [0, 2], [0, 3], [0, 3], [1, 2], [1, 2], [1, 3], [1, 3]
    ]

    @classmethod
    def setUpClass(cls) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            db.execute(insert(Food).values([{"name": name} for name in cls.foods]))
            db.execute(insert(Hobby).values([{"name": name} for name in cls.hobbies]))
            db.execute(insert(Movie).values([{"name": name} for name in cls.movies]))
            db.execute(insert(Location).values([{"name": name} for name in cls.locations]))
            lang_ids = list(db.scalars(insert(Language).values([{"name": name} for name in cls.languages]).returning(Language.id)))

            email_ids = db.scalars(insert(Email).values([{"email": email} for email in cls.user_emails]).returning(Email.id))
            verification_ids = db.scalars(insert(EmailVerification).values([{
                    "token": cls.token,
                    "email_id": email_id
                } for email_id in email_ids]).returning(EmailVerification.id))
            profile_ids = list(db.scalars(insert(Profile).values([{
                    "name": name,
                    "birth": date.today(),
                    "sex": "male",
                    "major": "Hello",
                    "admission_year": 2023,
                    "nation_code": nation_code,
                } for name, nation_code in zip(cls.user_names, cls.user_nation_codes)]).returning(Profile.id)))
            db.execute(insert(User).values([{
                    "user_id": profile_id,
                    "verification_id": verification_id,
                    "lang_id": lang_ids[main_lang_idx],
                    "salt": "",
                    "hash": ""
                } for profile_id, verification_id, main_lang_idx in zip(profile_ids, verification_ids, cls.user_main_lang_idxs)]))
            db.execute(insert(user_lang).values([{
                    "user_id": user_id,
                    "lang_id": lang_ids[lang_idx]
                } for user_id, lang_idxs in zip(profile_ids, cls.user_lang_idxs) for lang_idx in lang_idxs]))
            db.commit()

    @classmethod
    @inject_db
    def tearDownClass(cls, db: DbSession) -> None:
        db.execute(delete(User))
        db.execute(delete(Profile))
        db.execute(delete(Email))
        db.execute(delete(Language))
        db.execute(delete(Location))
        db.execute(delete(Movie))
        db.execute(delete(Hobby))
        db.execute(delete(Food))
        db.commit()

    @inject_db
    def tearDown(self, db: DbSession) -> None:
        db.execute(delete(Email).where(Email.email == self.email))
        db.commit()

    @inject_db
    def test_create_verification_code(self, db: DbSession):
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

    @inject_db
    def test_check_verification_code(self, db: DbSession) -> None:
        valid_req = VerificationRequest(email=self.email, code=self.code)
        invalid_email_req = VerificationRequest(email=self.naver_email, code=self.code)
        invalid_code_req = VerificationRequest(email=self.email, code=0)

        db.add(EmailCode(code=self.code, email=Email(email=self.email)))
        db.flush()

        check_verification_code(valid_req, db)
        with self.assertRaises(InvalidEmailCodeException):
            check_verification_code(invalid_email_req, db)
        with self.assertRaises(InvalidEmailCodeException):
            check_verification_code(invalid_code_req, db)

    @inject_db
    def test_create_verification(self, db: DbSession):
        email_id = db.scalar(insert(Email).values({"email": self.email}).returning(Email.id))

        self.assertEqual(
            create_verification(self.email, email_id, db),
            db.scalar(select(EmailVerification.token).join(EmailVerification.email).where(Email.email == self.email)),
        )
        self.assertEqual(
            create_verification(self.email, email_id, db),
            db.scalar(select(EmailVerification.token).join(EmailVerification.email).where(Email.email == self.email)),
            )

    @inject_db
    def test_check_verification_token(self, db: DbSession) -> None:
        profile = ProfileData(name="", birth=date.today(), sex="", major="", admission_year=2000, about_me=None, mbti=None,
                          nation_code=KOREA_CODE, foods=[], movies=[], hobbies=[], locations=[])
        valid_req = CreateUserRequest(email=self.email, token=self.token, password="", profile=profile,
                                      main_language="", languages=[])
        invalid_email_req = CreateUserRequest(email=self.naver_email, token=self.token, password="", profile=profile,
                                              main_language="", languages=[])
        invalid_token_req = CreateUserRequest(email=self.email, token="", password="", profile=profile,
                                              main_language="", languages=[])

        db.add(EmailVerification(token=self.token, email=Email(email=self.email)))
        db.flush()

        check_verification_token(valid_req, db)
        with self.assertRaises(InvalidEmailTokenException):
            check_verification_token(invalid_email_req, db)
        with self.assertRaises(InvalidEmailTokenException):
            check_verification_token(invalid_token_req, db)

    def test_create_user(self):
        for db in DbConnector.get_db():
            email_id = db.scalar(insert(Email).values({"email": self.email}).returning(Email.id))
            verification_id = db.scalar(insert(EmailVerification).values({"email_id": email_id, "token": self.token}).returning(EmailVerification.id))
            db.commit()

        for db in DbConnector.get_db():
            req = CreateUserRequest(email=self.email, token=self.token, password="", profile=ProfileData(
                    name=self.name, birth=date.today(), sex="male", major="Hello", admission_year=2023,
                    nation_code=13, foods=['A', 'B'], movies=['A', 'B'], hobbies=['A', 'B'], locations=['A', 'B']
                ), main_language='A', languages=['B'])
            user_id = create_user(req, verification_id, db)
            user = db.query(User).join(User.profile).where(Profile.name == self.name).first()
            self.assertEqual(user.user_id, user_id)
            self.assertEqual(user.profile.name, self.name)
            self.assertEqual(set(map(lambda item: item.name, user.profile.foods)), {'A', 'B'} )
            self.assertEqual(set(map(lambda item: item.name, user.profile.movies)), {'A', 'B'})
            self.assertEqual(set(map(lambda item: item.name, user.profile.hobbies)), {'A', 'B'})
            self.assertEqual(set(map(lambda item: item.name, user.profile.locations)), {'A', 'B'})
            self.assertEqual(set(map(lambda item: item.name, user.languages)), {'A', 'B'})
            with self.assertRaises(EmailInUseException):
                create_user(req, verification_id, db)
        for db in DbConnector.get_db():
            req = CreateUserRequest(email=self.email, token=self.token, password="", profile=ProfileData(
                    name=self.name, birth=date.today(), sex="male", major="Hello", admission_year=2023,
                    nation_code=KOREA_CODE, foods=['A', 'B'], movies=['A', 'B'], hobbies=['A', 'B'], locations=['A', 'B']
                ), main_language='A', languages=['B'])
            user_id = create_user(req, verification_id, db)
            user = db.query(User).join(User.profile).where(Profile.name == self.name).first()
            self.assertEqual(set(map(lambda item: item.name, user.languages)), {'B'})
        for db in DbConnector.get_db():
            req = CreateUserRequest(email=self.email, token=self.token, password="", profile=ProfileData(
                    name=self.name, birth=date.today(), sex="male", major="Hello", admission_year=2023,
                    nation_code=KOREA_CODE, foods=['A', 'X'], movies=['A', 'B'], hobbies=['A', 'B'], locations=['A', 'B']
                ), main_language='A', languages=['B'])
            with self.assertRaises(InvalidFoodException):
                create_user(req, verification_id, db)
        for db in DbConnector.get_db():
            req = CreateUserRequest(email=self.email, token=self.token, password="", profile=ProfileData(
                    name=self.name, birth=date.today(), sex="male", major="Hello", admission_year=2023,
                    nation_code=KOREA_CODE, foods=['A', 'B'], movies=['A', 'X'], hobbies=['A', 'B'], locations=['A', 'B']
                ), main_language='A', languages=['B'])
            with self.assertRaises(InvalidMovieException):
                create_user(req, verification_id, db)
        for db in DbConnector.get_db():
            req = CreateUserRequest(email=self.email, token=self.token, password="", profile=ProfileData(
                    name=self.name, birth=date.today(), sex="male", major="Hello", admission_year=2023,
                    nation_code=KOREA_CODE, foods=['A', 'B'], movies=['A', 'B'], hobbies=['A', 'X'], locations=['A', 'B']
                ), main_language='A', languages=['B'])
            with self.assertRaises(InvalidHobbyException):
                create_user(req, verification_id, db)
        for db in DbConnector.get_db():
            req = CreateUserRequest(email=self.email, token=self.token, password="", profile=ProfileData(
                    name=self.name, birth=date.today(), sex="male", major="Hello", admission_year=2023,
                    nation_code=KOREA_CODE, foods=['A', 'B'], movies=['A', 'B'], hobbies=['A', 'B'], locations=['A', 'X']
                ), main_language='A', languages=['B'])
            with self.assertRaises(InvalidLocationException):
                create_user(req, verification_id, db)
        for db in DbConnector.get_db():
            req = CreateUserRequest(email=self.email, token=self.token, password="", profile=ProfileData(
                    name=self.name, birth=date.today(), sex="male", major="Hello", admission_year=2023,
                    nation_code=KOREA_CODE, foods=['A', 'B'], movies=['A', 'B'], hobbies=['A', 'B'], locations=['A', 'B']
                ), main_language='X', languages=['B'])
            with self.assertRaises(InvalidLanguageException):
                create_user(req, verification_id, db)
        for db in DbConnector.get_db():
            req = CreateUserRequest(email=self.email, token=self.token, password="", profile=ProfileData(
                    name=self.name, birth=date.today(), sex="male", major="Hello", admission_year=2023,
                    nation_code=KOREA_CODE, foods=['A', 'B'], movies=['A', 'B'], hobbies=['A', 'B'], locations=['A', 'B']
                ), main_language='A', languages=['X'])
            with self.assertRaises(InvalidLanguageException):
                create_user(req, verification_id, db)

    def test_create_salt_hash(self):
        salt, hash = create_salt_hash('')
        self.assertEqual(len(salt), 24)
        self.assertEqual(len(hash), 44)

    @inject_db
    def test_get_target_users(self, db: DbSession):
        kor_user = db.query(User).join(User.profile).where(Profile.name == 'user1').first()
        for_user = db.query(User).join(User.profile).where(Profile.name == 'user8').first()

        targets = list(map(lambda user: user.profile.name, get_target_users(kor_user, db)))
        self.assertEqual(set(targets), set(['user2', 'user4', 'user6']))
        targets = list(map(lambda user: user.profile.name, get_target_users(for_user, db)))
        self.assertEqual(set(targets), set(['user7', 'user3', 'user5']))

    def test_get_user_dataframe(self):
        my_profile = Profile(
            name="sangin", birth=date(1999, 5, 14), sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            mbti="isfj", nation_code=82,
            foods=["korean_food", "japan_food"],
            movies=["horror"],
            locations=["up", "down", "jahayeon"],
            hobbies=["soccer", "golf"]
        )
        me = User(user_id = 0, verification_id=1, lang_id=1, salt="1", hash="1", profile=my_profile)
        df_answer = pd.DataFrame.from_dict({
            "id":0,
            "foods":["korean_food", "japan_food"],
            "movies":["horror"],
            "hobbies": ["soccer", "golf"],
            "locations":["up", "down", "jahayeon"],
                              }, orient="index").T
        df_me = get_user_dataframe(me)
        features = ["id", "foods", "movies", "hobbies", "locations"]
        for feature in features:
            self.assertEqual(df_me.loc[:, feature].values, df_answer.loc[:, feature].values)

    def test_get_similarity(self):
        df_me1 = pd.DataFrame.from_dict({
            "id":0,
            "foods":["korean_food", "italian_food", "chinese_food"],
            "movies":["horror", "action", "romance"],
            "hobbies": ["soccer", "book"],
            "locations":["jahayeon"],
                              }, orient="index").T
        df_target1 = pd.DataFrame.from_dict({
            "id":2,
            "foods":["korean_food", "japan_food"],
            "movies":["horror"],
            "hobbies": ["soccer", "golf"],
            "locations":["up", "down", "jahayeon"],
                              }, orient="index").T

        df_me2 = pd.DataFrame.from_dict({
            "id": 0,
            "foods": ["korean_food", "italian_food", "chinese_food"],
            "movies": ["horror", "action", "romance"],
            "hobbies": ["soccer", "book"],
            "locations": ["jahayeon"],
        }, orient="index").T
        df_target2 = pd.DataFrame.from_dict({
            "id": 2,
            "foods": ["japan_food"],
            "movies": ["thriller", "drama", "comedy"],
            "hobbies": ["golf"],
            "locations": ["up", "down"],
        }, orient="index").T

        self.assertEqual(get_similarity(df_me1, df_target1), 4/np.sqrt(72))
        self.assertEqual(get_similarity(df_me2, df_target2), 0)


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

        # 0.5345, 0.7826, 0.5773
        result = sort_target_users(me, yous)
        self.assertEqual(result[0].user_id, 2)
        self.assertEqual(result[0].profile.name, "abdula")
        self.assertEqual(result[1].user_id, 3)
        self.assertEqual(result[1].profile.name, "jiho")
        self.assertEqual(result[2].user_id, 1)
        self.assertEqual(result[2].profile.name, "sangin")

        result = sort_target_users(me, [])
        self.assertEqual(result, [])


if __name__ == '__main__':
    unittest.main()
