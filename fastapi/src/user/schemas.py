from datetime import date
from enum import Enum
from typing import List

from pydantic import BaseModel, EmailStr


class EmailRequest(BaseModel):
    email: EmailStr


class VerificationRequest(BaseModel):
    email: EmailStr
    code: int


class VerificationResponse(BaseModel):
    token: str


class ProfileData(BaseModel):
    name: str
    birth: date
    sex: str
    major: str
    admission_year: int
    about_me: str | None = None
    mbti: str | None = None
    nation_code: int
    foods: List[str]
    movies: List[str]
    hobbies: List[str]
    locations: List[str]


class CreateUserRequest(BaseModel):
    email: EmailStr
    token: str
    password: str
    profile: ProfileData
    main_language: str
    languages: List[str]


class UserResponse(BaseModel):
    name: str
    email: EmailStr
    profile: ProfileData
    type: str
    main_language: str
    languages: List[str]


class UserType(Enum):
    Kor = 'korean'
    For = 'foreign'
