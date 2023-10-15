from pydantic import BaseModel, EmailStr


class EmailRequest(BaseModel):
    email: EmailStr


class VerificationRequest(BaseModel):
    email: EmailStr
    code: int


class VerificationResponse(BaseModel):
    token: str


class UserProfile(BaseModel):
    pass


class CreateUserRequest(BaseModel):
    email: EmailStr
    password: str
    user: UserProfile
