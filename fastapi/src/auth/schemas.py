from pydantic import BaseModel


class SessionResponse(BaseModel):
    access_token: str
    token_type: str
