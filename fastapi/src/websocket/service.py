from typing import Any, Tuple

from fastapi import WebSocket, WebSocketDisconnect
from fastapi.concurrency import run_in_threadpool
from sqlalchemy import insert

from src.auth.dependencies import *
from src.auth.models import Session
from src.chatting.models import *
from src.database import DbConnector
from src.websocket.dependencies import *


async def authenticate_socket(socket: WebSocket) -> Session:
    msg = await socket.receive_json()  # Raise WebSocketDisconnect on close

    try:
        if msg["type"] != "system":
            await socket.close(reason="invalid authentication")
            raise WebSocketDisconnect()
        session_key = str(msg["body"]["session_key"])
    except (KeyError, ValueError, TypeError):
        await socket.close(reason="invalid authentication")
        raise WebSocketDisconnect()

    try:
        for db in await run_in_threadpool(DbConnector.get_db):
            session = await run_in_threadpool(get_session, session_key, db)
            await socket.send_json({"type": "system", "body": {"msg": "authentication succeeded"}})
            return session
    except InvalidSessionException:
        await socket.close(reason="invalid authentication")
        raise WebSocketDisconnect()


async def handle_message(user_id: int, msg, socket: WebSocket, manager: WebSocketManager):
    msg = await parse_message(msg, socket)
    if msg is None:
        return
    chatting_id, msg = msg

    for db in await run_in_threadpool(DbConnector.get_db):
        chatting = await run_in_threadpool(get_chatting, chatting_id, db)
        if chatting is None or chatting.initiator_id != user_id and chatting.responder_id != user_id:
            await socket.send_json({"type": "system", "body": {"msg": "chatting does not exist"}})
            return
        if chatting.is_terminated:
            await socket.send_json({"type": "system", "body": {"msg": "chatting is already terminated"}})
            return
        if user_id == chatting.responder_id and chatting.is_approved is False:
            await socket.send_json({"type": "system", "body": {"msg": "please approve chatting first"}})
            return

        text = await run_in_threadpool(create_text, user_id, chatting_id, msg, db)
        for recv_socket in await manager.get_sockets([chatting.initiator_id, chatting.responder_id]):
            try:
                await recv_socket.send_json(text)
            except WebSocketDisconnect:
                pass


async def parse_message(msg, socket: WebSocket) -> Tuple[int, str] | None:
    try:
        if msg["type"] != "message":
            await socket.send_json({"type": "system", "body": {"msg": "invalid message"}})
            return None
        return int(msg["body"]["chatting_id"]), str(msg["body"]["msg"])
    except (KeyError, ValueError, TypeError):
        await socket.send_json({"type": "system", "body": {"msg": "invalid message"}})
        return None


def get_chatting(chatting_id: int, db: DbSession) -> Chatting | None:
    return db.query(Chatting).where(Chatting.id == chatting_id).first()


def create_text(sender_id: int, chatting_id: int, msg: str, db: DbSession) -> Any:
    text = db.scalar(insert(Text).values({
        "chatting_id": chatting_id,
        "sender_id": sender_id,
        "msg": msg,
        "timestamp": datetime.now(),
    }).returning(Text))
    db.commit()
    return {
        "type": "message",
        "body": {
            "seq_id": text.id,
            "chatting_id": text.chatting_id,
            "sender": text.sender.profile.name,
            "email": text.sender.verification.email.email,
            "msg": text.msg,
            "timestamp": str(text.timestamp),
        }
    }
