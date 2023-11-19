from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends

from src.websocket import service
from src.websocket.dependencies import *


router = APIRouter(prefix="/ws", tags=["chatting"])


@router.websocket("/connect")
async def websocket(socket: WebSocket, manager: WebSocketManager = Depends(get_socket_manager)):
    await socket.accept()

    try:
        user_id, session_key = await service.authenticate_socket(socket)
    except WebSocketDisconnect:
        return

    await manager.add_socket(user_id, session_key, socket)

    try:
        while True:
            msg = await socket.receive_json()
            await service.handle_message(user_id, msg, socket, manager)
    except WebSocketDisconnect:
        await manager.remove_socket(user_id, session_key, socket)
