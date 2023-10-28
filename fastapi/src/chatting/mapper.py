from src.chatting.schemas import *
from src.chatting.models import *
from src.user.mapper import from_user


def from_chatting(chatting: Chatting) -> ChattingResponse:
    return ChattingResponse(
        initiator=from_user(chatting.initiator),
        responder=from_user(chatting.responser),
        is_approved=chatting.is_approved,
        is_terminated=chatting.is_terminated,
        created_at=chatting.created_at,
    )


def from_text(text: Text) -> TextResponse:
    return TextResponse(
        seq_id=text.id,
        chatting_id=text.chatting_id,
        sender=text.sender.profile.name,
        email=text.sender.verification.email.email,
        msg=text.msg,
        timestamp=text.timestamp,
    )
