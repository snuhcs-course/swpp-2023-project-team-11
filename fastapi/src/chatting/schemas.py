from datetime import datetime

from pydantic import BaseModel

from src.user.schemas import UserResponse


class CreateChattingRequest(BaseModel):
    counterpart: str  # email


class ChattingResponse(BaseModel):
    chatting_id: int
    initiator: UserResponse
    responder: UserResponse
    is_approved: bool
    is_terminated: bool
    created_at: datetime


class TextResponse(BaseModel):
    seq_id: int
    chatting_id: int
    sender: str
    email: str
    msg: str
    timestamp: datetime

class IntimacyResponse(BaseModel):
    chatting_id: int
    intimacy: float
    timestamp: datetime

class TopicResponse(BaseModel):
    topic_id: int
    topic: str
    tag: str