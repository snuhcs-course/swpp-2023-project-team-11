from asyncio import Lock
from typing import Dict, List

from fastapi import WebSocket, WebSocketDisconnect


class WebSocketManager:
    def __init__(self):
        self.__lock = Lock()
        self.__sockets: Dict[int, Dict[str, WebSocket]] = dict()
    
    async def add_socket(self, user_id: int, session_key: str, socket: WebSocket):
        """
        Add new socket to the manager.
        If the socket already exists, that socket must be closed before being replaced.
        """

        async with self.__lock:
            if self.__sockets.get(user_id) is None:
                self.__sockets[user_id] = dict()
            old = self.__sockets[user_id].pop(session_key, None)
            if old is not None:
                try:
                    await old.close(reason="another connection detected")
                except WebSocketDisconnect:
                    pass
            self.__sockets[user_id][session_key] = socket

    async def remove_socket(self, user_id: int, session_key: str, socket: WebSocket):
        """
        Remove the closed socket from the manager.
        The socket is already removed if closed by the server.
        """

        async with self.__lock:
            try:
                if self.__sockets[user_id][session_key] == socket:
                    self.__sockets[user_id].pop(session_key)
            except KeyError:
                pass

    async def get_sockets(self, user_ids: List[int]) -> List[WebSocket]:
        def __get_sockets(user_id: int) -> Dict[str, WebSocket]:
            try:
                return self.__sockets[user_id]
            except KeyError:
                return {}

        async with self.__lock:
            return list(socket for user_id in user_ids for socket in __get_sockets(user_id).values())


# Global WebSocket Manager
__manager = WebSocketManager()


def get_socket_manager() -> WebSocketManager:
    return __manager
