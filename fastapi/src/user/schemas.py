from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class EmailRequest(BaseModel):
    email: str


class VerificationRequest(BaseModel):
    email: str
    code: int


class VerificationResponse(BaseModel):
    token: str


class SessionRequest(BaseModel):
    email: str
    password: str


class UserProfile(BaseModel):
    pass


class CreateUserRequest(BaseModel):
    email: str
    password: str
    user: UserProfile


