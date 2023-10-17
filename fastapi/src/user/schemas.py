from datetime import date
from typing import List

from pydantic import BaseModel, EmailStr


class EmailRequest(BaseModel):
    email: EmailStr


class VerificationRequest(BaseModel):
    email: EmailStr
    code: int


class VerificationResponse(BaseModel):
    token: str


class Profile(BaseModel):
    name: str
    birth: date
    sex: str
    major: str
    admission_year: int
    about_me: str | None
    mbti: str | None
    country: str
    foods: List[str]
    movies: List[str]
    hobbies: List[str]
    locations: List[str]

    class Config:
        from_attributes = True


class CreateUserRequest(BaseModel):
    email: EmailStr
    token: str
    password: str
    profile: Profile


class UserResponse(BaseModel):
    name: str
    email: EmailStr
    profile: Profile
    type: str
    main_language: str
    languages: List[str]
