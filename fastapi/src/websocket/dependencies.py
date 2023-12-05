from abc import ABC, abstractmethod
from asyncio import Lock
from typing import Dict, Set, Tuple, List

from fastapi import WebSocket, WebSocketDisconnect
from sqlalchemy.ext.asyncio import AsyncSession

from src.chatting.models import Chatting, Text
from src.user.models import EmailVerification, Email, Profile
from src.user.service import async_get_user_by_id
from src.websocket import service


class GetUser(ABC):
    """Gets user data."""

    @abstractmethod
    async def get_name_and_email(self, db: AsyncSession, user_id: int) -> Tuple[str, str]:
        """Get user name and email."""


class BaseGetUser(GetUser):
    """Default get user from database."""

    async def get_name_and_email(self, db: AsyncSession, user_id: int) -> Tuple[str, str]:
        user = await async_get_user_by_id(db, user_id)
        profile: Profile = await user.awaitable_attrs.profile
        verification: EmailVerification = await user.awaitable_attrs.verification
        email: Email = await verification.awaitable_attrs.email
        return profile.name, email.email


class CachedGetUser(GetUser):
    """Cached get user."""

    def __init__(self, inner: GetUser):
        self.__name_email: Dict[int, Tuple[str, str]] = dict()
        self.__inner = inner

    async def get_name_and_email(self, db: AsyncSession, user_id: int) -> Tuple[str, str]:
        if user_id not in self.__name_email:
            self.__name_email[user_id] = await self.__inner.get_name_and_email(db, user_id)
        return self.__name_email[user_id]


class WebSocketManager:
    def __init__(self, get_user: GetUser):
        self.__sockets: Dict[int, Set[WebSocket]] = dict()
        self.__get_user = get_user
        self.__lock = Lock()

    async def add(self, socket: WebSocket, user_id: int):
        async with self.__lock:
            if user_id not in self.__sockets:
                self.__sockets[user_id] = set()
            self.__sockets[user_id].add(socket)

    async def remove(self, socket: WebSocket, user_id: int):
        async with self.__lock:
            try:
                self.__sockets[user_id].remove(socket)
                if len(self.__sockets[user_id]) == 0:
                    self.__sockets.pop(user_id)
            except KeyError:
                pass

    async def get_sockets(self, user_id: Tuple[int, int]) -> List[WebSocket]:
        async with self.__lock:
            sockets = []
            if user_id[0] in self.__sockets:
                sockets += list(self.__sockets[user_id[0]])
            if user_id[1] in self.__sockets:
                sockets += list(self.__sockets[user_id[1]])
            return sockets

    async def handle(self, db: AsyncSession, user_id: int, chatting: Chatting, text: Text):
        sender, email = await self.__get_user.get_name_and_email(db, user_id)
        for socket in await self.get_sockets((chatting.initiator_id, chatting.responder_id)):
            try:
                await service.send_msg(socket, text.id, text.proxy_id, text.chatting_id, sender, email, text.msg, text.timestamp)
            except WebSocketDisconnect:
                pass


# Global WebSocket Manager
__get_user = BaseGetUser()
__get_user = CachedGetUser(__get_user)
__manager = WebSocketManager(__get_user)


def get_socket_manager() -> WebSocketManager:
    return __manager
