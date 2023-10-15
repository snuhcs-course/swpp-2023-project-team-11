from pydantic import BaseModel


class EmailRequest(BaseModel):
    email: str


class VerificationRequest(BaseModel):
    email: str
    code: int


class VerificationResponse(BaseModel):
    token: str


class UserProfile(BaseModel):
    pass


class CreateUserRequest(BaseModel):
    email: str
    password: str
    user: UserProfile
