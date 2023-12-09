from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends
from websockets.exceptions import ConnectionClosedError

from src.auth.exceptions import InvalidSessionException
from src.auth.service import async_get_session_by_key
from src.chatting.exceptions import ChattingNotExistException
from src.chatting.service import async_get_chatting_by_id, async_create_text, validate_chatting_status
from src.database import DbConnector
from src.websocket import service
from src.websocket.dependencies import *
from src.websocket.exceptions import *


router = APIRouter(prefix="/ws", tags=["chatting"])


@router.websocket("/connect")
async def websocket(socket: WebSocket, manager: WebSocketManager = Depends(get_socket_manager)):
    # The socket must be accepted first.
    await socket.accept()

    # The socket must perform authentication.
    try:
        session_key = await service.receive_authentication(socket)
        async for db in DbConnector.get_async_db():
            session = await async_get_session_by_key(db, session_key)
        user_id = session.user_id
    except (InvalidMessageException, InvalidSessionException) as exc:
        # Failed to authenticate, so close and terminate this coroutine.
        await socket.close(reason=exc.detail)
        return
    except (RuntimeError, WebSocketDisconnect, ConnectionClosedError):
        return

    async with WebSocketHandle(manager, socket, user_id):
        try:
            while True:
                try:
                    chatting_id, proxy_id, msg = await service.receive_msg(socket)
                    async for db in DbConnector.get_async_db():
                        chatting = await async_get_chatting_by_id(db, chatting_id)
                        validate_chatting_status(user_id, chatting)
                        text = await async_create_text(db, chatting_id, user_id, proxy_id, msg)
                        await db.commit()

                    await manager.handle(db, user_id, chatting, text)
                except (InvalidMessageException, ChattingNotExistException) as exc:
                    # Invalid socket message. Stop handling and send system message.
                    await service.send_system_msg(socket, exc.detail)
        except (RuntimeError, WebSocketDisconnect, ConnectionClosedError):
            return
