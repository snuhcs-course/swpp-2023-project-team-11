from src.chatting.schemas import *
from src.chatting.models import *
from src.user.mapper import from_user


def from_chatting(chatting: Chatting, user_id: str) -> ChattingResponse:
    #filter chatting.intimacies by user_id
    _intimacies = chatting.intimacies
    filtered_intimacies = filter(lambda x: x.user_id == user_id, _intimacies)
    filtered_intimacies = sorted(filtered_intimacies, key=lambda x: x.timestamp, reverse=True)
    #get recent intimacy from filtered_intimacies
    recent_intimacy = filtered_intimacies[0].intimacy if len(filtered_intimacies) > 0 else 36.5
   
    return ChattingResponse(
        chatting_id=chatting.id,
        initiator=from_user(chatting.initiator),
        responder=from_user(chatting.responder),
        is_approved=chatting.is_approved,
        is_terminated=chatting.is_terminated,
        created_at=chatting.created_at,
        recent_intimacy=recent_intimacy,
    
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


def from_intimacy(intimacy: Intimacy) -> IntimacyResponse:
    return IntimacyResponse(
        chatting_id=intimacy.chatting_id,
        intimacy=intimacy.intimacy,
        timestamp=intimacy.timestamp,
    )


def from_topic(topic: Topic) -> TopicResponse:
    return TopicResponse(
        topic=topic.topic,
        tag=topic.tag,
    )
