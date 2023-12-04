from datetime import datetime
from typing import Tuple

from fastapi import WebSocket

from src.websocket.exceptions import *


async def receive_authentication(socket: WebSocket) -> str:
    """Raises `WebSocketDisconnect`, `InvalidMessageException`."""

    try:
        auth = await socket.receive_json()
        if auth["type"] != "system":
            raise InvalidMessageTypeException()
        return str(auth["body"]["session_key"])
    except (KeyError, ValueError, TypeError):
        raise InvalidMessageException('Invalid authentication format')


async def receive_msg(socket: WebSocket) -> Tuple[int, int, str]:
    """Raises `WebSocketDisconnect`, `InvalidMessageException`."""

    try:
        msg = await socket.receive_json()
        if msg["type"] != "message":
            raise InvalidMessageTypeException()
        return int(msg['body']['chatting_id']), int(msg['body']['proxy_id']), str(msg['body']['msg'])
    except (KeyError, ValueError, TypeError):
        raise InvalidMessageException("Invalid text format")


async def send_msg(socket: WebSocket, seq_id: int, proxy_id: int, chatting_id: int, sender: str, email: str, msg: str, timestamp: datetime):
    """Raises `WebSocketDisconnect`."""

    await socket.send_json({
        "type": "message",
        "body": {
            "seq_id": seq_id,
            "proxy_id": proxy_id,
            "chatting_id": chatting_id,
            "sender": sender,
            "email": email,
            "msg": msg,
            "timestamp": str(timestamp),
        }
    })


async def send_system_msg(socket: WebSocket, msg: str):
    """Raises `WebSocketDisconnect`."""

    await socket.send_json({"type": "system", "body": {"msg": msg}})
