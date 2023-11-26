from datetime import date
from enum import Enum
from typing import Annotated, List

from pydantic import BaseModel, EmailStr, Field


class EmailRequest(BaseModel):
    email: EmailStr = Field(description="SNU email",
                            examples=["test@snu.ac.kr"])


class VerificationRequest(BaseModel):
    email: EmailStr = Field(description="SNU email",
                            examples=["test@snu.ac.kr"])
    code: int = Field(description="email verification code", examples=[182653])


class VerificationResponse(BaseModel):
    token: str = Field(description="email validation token",
                       examples=["aljsd837nsdjfdsEjDFf3A_="])


class ProfileData(BaseModel):
    name: str = Field(description="user name", examples=["SNEK"])
    birth: date
    sex: str
    major: str
    admission_year: int = Field(examples=[2023])
    about_me: str | None = Field(
        None, description="self introduction", examples=[None])
    mbti: str | None = Field(None, description="MBTI", examples=["INTJ"])
    nation_code: int = Field(examples=[82])
    foods: List[str] = Field(examples=[[]])
    movies: List[str] = Field(examples=[[]])
    hobbies: List[str] = Field(examples=[[]])
    locations: List[str] = Field(examples=[[]])


class CreateUserRequest(BaseModel):
    email: EmailStr = Field(description="SNU email",
                            examples=["test@snu.ac.kr"])
    token: str = Field(description="email validation token",
                       examples=["aljsd837nsdjfdsEjDFf3A_="])
    password: str = Field(description="initial password",
                          examples=["password"])
    profile: ProfileData = Field(description="user profile")
    main_language: str = Field(
        description="user's main language", examples=["korean"])
    languages: List[str] = Field(
        description="for korean students: desiring languages, for foreign students: available languages", examples=[["japanese", "english"]])


class UpdateUserRequest(BaseModel):
    food: List[str] = Field(default=[], description="list of food tags", examples=[["korean"]])
    movie: List[str] = Field(default=[], description="list of movie tags", examples=[["action"]])
    hobby: List[str] = Field(default=[], description="list of hobby tags", examples=[["yoga"]])
    location: List[str] = Field(default=[], description="list of location tags", examples=[["jahayeon"]])
    lang: List[str] = Field(default=[], description="list of desired/available languages", examples=[["korean"]])


class UserResponse(BaseModel):
    name: str = Field(description="user name", examples=["SNEK"])
    email: EmailStr = Field(description="SNU email",
                            examples=["test@snu.ac.kr"])
    profile: ProfileData = Field(description="user profile")
    type: str = Field(description="korean or foreign", examples=["korean"])
    main_language: str = Field(
        description="user's main language", examples=["korean"])
    languages: List[str] = Field(
        description="for korean students: desiring languages, for foreign students: available languages", examples=[["japanese", "english"]])


class UserType(Enum):
    Kor = 'korean'
    For = 'foreign'
