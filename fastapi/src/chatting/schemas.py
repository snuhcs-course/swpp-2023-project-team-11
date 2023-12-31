from datetime import datetime

from pydantic import BaseModel, Field

from src.user.schemas import UserResponse


class CreateChattingRequest(BaseModel):
    counterpart: str = Field(
        description="user email to request chatting", examples=["test@snu.ac.kr"])


class ChattingResponse(BaseModel):
    chatting_id: int
    initiator: UserResponse = Field(description="chatting initiator")
    responder: UserResponse = Field(description="chatting responder")
    is_approved: bool = Field(
        description="whether chatting is approved by responder")
    is_terminated: bool = Field(description="whether chatting is terminated")
    recent_intimacy: float = Field(
        description="recent intimacy value", examples=[41.37262])
    created_at: datetime


class TextResponse(BaseModel):
    seq_id: int = Field(description="global sequence id for all text messages")
    proxy_id: int
    chatting_id: int
    sender: str = Field(description="sender name", examples=["snek"])
    email: str = Field(description="sender email", examples=["test@snu.ac.kr"])
    msg: str = Field(description="text message",
                     examples=["Hi, nice to meet you"])
    timestamp: datetime


class IntimacyResponse(BaseModel):
    chatting_id: int
    intimacy: float = Field(description="intimacy value", examples=[41.37262])
    timestamp: datetime


class TopicResponse(BaseModel):
    topic_kor: str = Field(examples=["좋아하는 책에 대한 이야기"])
    topic_eng: str = Field(examples=["Talk about your favorite book"])
    tag: str = Field(examples=["C"])
