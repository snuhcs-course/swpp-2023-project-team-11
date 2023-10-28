from datetime import datetime

from pydantic import BaseModel

from src.user.schemas import UserResponse


class ChattingResponse(BaseModel):
    initiator: UserResponse
    responser: UserResponse
    is_approved: bool
    is_terminated: bool
    created_at: datetime


class TextResponse(BaseModel):
    seq_id: int
    chatting_id: int
    sender: str
    msg: str
    timestamp: datetime
