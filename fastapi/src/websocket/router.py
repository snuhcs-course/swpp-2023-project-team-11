from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends

from src.websocket import service
from src.websocket.dependencies import *


router = APIRouter(prefix="/ws", tags=["chatting"])


@router.websocket("/connect")
async def websocket(socket: WebSocket, manager: WebSocketManager = Depends(get_socket_manager)):
    await socket.accept()

    try:
        session = await service.authenticate_socket(socket)
    except WebSocketDisconnect:
        return

    await manager.add_socket(session.user_id, session.session_key, socket)

    try:
        while True:
            msg = await socket.receive_json()
            await service.handle_message(session.user_id, msg, socket, manager)
    except WebSocketDisconnect:
        await manager.remove_socket(session.user_id, session.session_key, socket)
