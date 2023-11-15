from pydantic import BaseModel, Field


class SessionResponse(BaseModel):
    access_token: str = Field(
        description="session key", examples=["session-key"])
    token_type: str = Field(description="bearer", examples=["bearer"])
