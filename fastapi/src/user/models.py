from datetime import date
from typing import List

from sqlalchemy import Column, Integer, String, ForeignKey, Table, Date
from sqlalchemy.orm import Mapped, relationship

from src.database import Base


class Email(Base):
    __tablename__ = "email"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    email: Mapped[str] = Column(String(31), nullable=False, unique=True)

    code: Mapped["EmailCode"] = relationship(back_populates="email")
    verification: Mapped["EmailVerification"] = relationship(back_populates="email")


class EmailCode(Base):
    __tablename__ = "email_code"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    email_id: Mapped[int] = Column(ForeignKey("email.id"), nullable=False, unique=True)
    code: Mapped[int] = Column(Integer, nullable=False)

    email: Mapped["Email"] = relationship(back_populates="code")


class EmailVerification(Base):
    __tablename__ = "email_verification"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    email_id: Mapped[int] = Column(ForeignKey("email.id"), nullable=False, unique=True)
    token: Mapped[str] = Column(String(44), nullable=False, unique=True)

    email: Mapped["Email"] = relationship(back_populates="verification")


user_hobby = Table(
    "user_hobby",
    Base.metadata,
    Column("user_id", ForeignKey("profile.id"), nullable=False),
    Column("hobby_id", ForeignKey("hobby.id"), nullable=False),
)


user_lang = Table(
    "user_lang",
    Base.metadata,
    Column("user_id", ForeignKey("users.user_id"), nullable=False),
    Column("lang_id", ForeignKey("language.id"), nullable=False),
)


class Food(Base):
    __tablename__ = "food"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = Column(String(31), nullable=False, unique=True)


class Movie(Base):
    __tablename__ = "movie"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = Column(String(63), nullable=False, unique=True)


class Hobby(Base):
    __tablename__ = "hobby"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = Column(String(31), nullable=False, unique=True)


class Language(Base):
    __tablename__ = "language"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = Column(String(31), nullable=False, unique=True)


class Country(Base):
    __tablename__ = "country"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = Column(String(31), nullable=False, unique=True)


class Profile(Base):
    __tablename__ = "profile"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = Column(String(31), nullable=False)
    birth: Mapped[date] = Column(Date, nullable=False)
    sex: Mapped[str] = Column(String(1), nullable=False)
    major: Mapped[str] = Column(String(63), nullable=False)
    admission_year: Mapped[int] = Column(Integer, nullable=False)
    about_me: Mapped[str] = Column(String(255))
    mbti: Mapped[int] = Column(Integer)
    food_id: Mapped[int] = Column(ForeignKey("food.id"))
    movie_id: Mapped[int] = Column(ForeignKey("movie.id"))

    favorite_food: Mapped[Food | None] = relationship()
    favorite_movie: Mapped[Movie | None] = relationship()
    hobbies: Mapped[List["Hobby"]] = relationship(secondary=user_hobby)
    user: Mapped["User"] = relationship(back_populates="profile")


class User(Base):
    __tablename__ = "users"

    user_id: Mapped[int] = Column(ForeignKey("profile.id"), primary_key=True)
    verification_id: Mapped[int] = Column(ForeignKey("email_verification.id"), nullable=False, unique=True)
    country_id: Mapped[int] = Column(ForeignKey("country.id"), nullable=False)

    salt: Mapped[str] = Column(String(24), nullable=False)
    hash: Mapped[str] = Column(String(44), nullable=False)

    profile: Mapped["Profile"] = relationship(back_populates="user")
    verification: Mapped["EmailVerification"] = relationship()
    country: Mapped["Country"] = relationship()