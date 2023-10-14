from sqlalchemy import Column, Integer, String, BigInteger, Date, ForeignKey

from src.database import Base


class Email(Base):
    __tablename__ = "email"

    email = Column(String(31), nullable=False, unique=True)
    email_id = Column(BigInteger, primary_key=True)


class EmailCode(Base):
    __tablename__ = "email_code"

    email_id = Column(BigInteger, nullable=False, unique=True, ForeignKey=Email.email_id)
    code = Column(Integer, nullable=False)


class VerifiedEmail(Base):
    __tablename__ = "verified_email"

    email_id = Column(BigInteger, nullable=False, unique=True, ForeignKey=Email.email_id)
    verification_id = Column(BigInteger, primary_key=True)


class Profile(Base):
    __tablename__ = "profile"
    user_id = Column(Integer, primary_key=True)
    name = Column(String(20), nullable=False)
    birth = Column(Date, nullable=False)
    sex = Column(String(1), nullable=False)
    major = Column(String(63), nullable=False)
    admission_year = Column(Integer, nullable=False)
    about_me = Column(String(255))
    mbti = Column(Integer)
    favorite_food = Column(Integer, ForeignKey("food.food_id"))
    favorite_movie = Column(Integer, ForeignKey("movie.movie_id"))

class Food(Base):
    __tablename__ = "food"
    food_id = Column(Integer, primary_key=True)
    food = Column(String(31), nullable=False, unique=True)


class Movie(Base):
    __tablename__ = "movie"
    movie_id = Column(Integer, primary_key=True)
    movie_name = Column(String(63), nullable=False, unique=True)


class Hobby(Base):
    __tablename__ = "hobby"
    hobby_id = Column(Integer, primary_key=True)
    hobby = Column(String(31), nullable=False, unique=True)


class UserHobby(Base):
    __tablename__ = "user_hobby"
    user_id = Column(Integer, ForeignKey("profile.user_id"))
    hobby_id = Column(Integer, ForeignKey("hobby.hobby_id"))
