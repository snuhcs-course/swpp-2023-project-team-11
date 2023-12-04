import unittest
from unittest.mock import AsyncMock, Mock

from src.websocket.dependencies import *
from src.websocket.service import *
from tests.utils import *


class TestGetUser(unittest.IsolatedAsyncioTestCase):
    def setUp(self) -> None:
        self.name = 'name'
        self.email = 'email'

        profile = Mock(name='profile')
        profile.name = self.name

        email = Mock(name='email')
        email.email = self.email

        verification = Mock(name='verification')
        verification.awaitable_attrs.email = coroutine(email)

        self.user1 = Mock(name='user')
        self.user1.awaitable_attrs.profile = coroutine(profile)
        self.user1.awaitable_attrs.verification = coroutine(verification)

        self.db: AsyncSession = Mock()
        self.db.scalar = AsyncMock()

    async def test_base(self):
        profile = Mock(name='profile')
        profile.name = self.email
        email = Mock(name='email')
        email.email = self.name
        verification = Mock(name='verification')
        verification.awaitable_attrs.email = coroutine(email)

        self.user2 = Mock(name='user')
        self.user2.awaitable_attrs.profile = coroutine(profile)
        self.user2.awaitable_attrs.verification = coroutine(verification)
        self.db.scalar.side_effect = [self.user1, self.user2]
        get_user = BaseGetUser()

        name, email = await get_user.get_name_and_email(self.db, 3)
        self.assertEqual(name, self.name)
        self.assertEqual(email, self.email)

        name, email = await get_user.get_name_and_email(self.db, 1)
        self.assertEqual(name, self.email)
        self.assertEqual(email, self.name)

    async def test_cache(self):
        self.db.scalar.return_value = self.user1
        get_user = CachedGetUser(BaseGetUser())

        name, email = await get_user.get_name_and_email(self.db, 3)
        self.assertEqual(name, self.name)
        self.assertEqual(email, self.email)

        name, email = await get_user.get_name_and_email(self.db, 3)
        self.assertEqual(name, self.name)
        self.assertEqual(email, self.email)


class TestWebSocketManager(unittest.IsolatedAsyncioTestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.name = 'name'
        cls.email = 'email'

    def setUp(self) -> None:
        get_user = Mock()
        get_user.get_name_and_email = AsyncMock(
            return_value=(self.name, self.email))

        self.manager = WebSocketManager(get_user)
        self.socket1: WebSocket = AsyncMock()
        self.socket2: WebSocket = AsyncMock()
        self.socket3: WebSocket = AsyncMock()
        self.socket4: WebSocket = AsyncMock()

    async def test_sockets(self):
        await self.manager.add(self.socket1, 3)
        await self.manager.add(self.socket1, 3)
        await self.manager.add(self.socket2, 1)
        await self.manager.add(self.socket3, 1)
        sockets_3 = await self.manager.get_sockets((3, 0))
        sockets_1 = await self.manager.get_sockets((1, 0))
        self.assertEqual(len(sockets_3), 1)
        self.assertEqual(len(sockets_1), 2)
        self.assertIn(self.socket1, sockets_3)
        self.assertIn(self.socket2, sockets_1)
        self.assertIn(self.socket3, sockets_1)

        await self.manager.remove(self.socket1, 1)
        sockets_3 = await self.manager.get_sockets((3, 0))
        sockets_1 = await self.manager.get_sockets((1, 0))
        self.assertEqual(len(sockets_3), 1)
        self.assertEqual(len(sockets_1), 2)
        self.assertIn(self.socket1, sockets_3)
        self.assertIn(self.socket2, sockets_1)
        self.assertIn(self.socket3, sockets_1)

        await self.manager.remove(self.socket1, 3)
        await self.manager.remove(self.socket1, 3)
        sockets_3 = await self.manager.get_sockets((3, 0))
        sockets_1 = await self.manager.get_sockets((1, 0))
        self.assertEqual(len(sockets_3), 0)
        self.assertEqual(len(sockets_1), 2)
        self.assertIn(self.socket2, sockets_1)
        self.assertIn(self.socket3, sockets_1)

    async def test_handle(self):
        await self.manager.add(self.socket1, 1)
        await self.manager.add(self.socket2, 2)
        await self.manager.add(self.socket3, 2)
        await self.manager.add(self.socket4, 3)

        chatting = Chatting(id=1, initiator_id=1, responder_id=2,
                            is_approved=True, is_terminated=False, created_at=datetime.now())
        text = Text(id=1, proxy_id=1, chatting_id=1, sender_id=1,
                    msg='hello', timestamp=datetime.now())

        await self.manager.handle(Mock('db'), 1, chatting, text)

        self.socket1.send_json.assert_awaited()
        self.socket2.send_json.assert_awaited()
        self.socket3.send_json.assert_awaited()
        self.socket4.send_json.assert_not_awaited()


class TestService(unittest.IsolatedAsyncioTestCase):
    def setUp(self) -> None:
        self.socket: WebSocket = Mock()
        self.socket.receive_json = AsyncMock()
        self.key = "key"
        self.proxy_id = 0
        self.chatting_id = -1
        self.msg = "msg"

    async def test_receive_authentication(self):
        self.socket.receive_json.side_effect = [
            {"type": "system", "body": {"session_key": self.key}},
            {"body": {"session_key": self.key}},
            {"type": "foo", "body": {"session_key": self.key}},
            {"type": "system"},
            {"type": "system", "body": 3},
            {"type": "system", "body": {}},
        ]

        session_key = await receive_authentication(self.socket)
        self.assertEqual(session_key, self.key)
        # Missing Type
        with self.assertRaises(InvalidMessageException):
            await receive_authentication(self.socket)
        # Wrong Type
        with self.assertRaises(InvalidMessageException):
            await receive_authentication(self.socket)
        # Missing Body
        with self.assertRaises(InvalidMessageException):
            await receive_authentication(self.socket)
        # Invalid Body Type
        with self.assertRaises(InvalidMessageException):
            await receive_authentication(self.socket)
        # Missing Session Key
        with self.assertRaises(InvalidMessageException):
            await receive_authentication(self.socket)

    async def test_receive_msg(self):
        self.socket.receive_json.side_effect = [
            {"body": {"proxy_id": 0, "chatting_id": 0, "msg": ""}},
            {"type": "foo", "body": {"proxy_id": 0, "chatting_id": 0, "msg": ""}},
            {"type": "message"},
            {"type": "message", "body": 3},
            {"type": "message", "body": {}},
            {"type": "message", "body": {"chatting_id": 0}},
            {"type": "message", "body": {"proxy_id": 0}},
            {"type": "message", "body": {"msg": ""}},
            {"type": "message", "body": {"chatting_id": 0, "proxy_id": 0}},
            {"type": "message", "body": {"proxy_id": 0, "msg": ""}},
            {"type": "message", "body": {"chatting_id": 0, "msg": ""}},
            {"type": "message", "body": {"proxy_id": 0, "chatting_id": "a", "msg": ""}},
            {"type": "message", "body": {"proxy_id": "a", "chatting_id": 0, "msg": ""}},
            {"type": "message", "body": {"proxy_id": self.proxy_id,
                                         "chatting_id": self.chatting_id, "msg": self.msg}},
        ]

        # Missing Type
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Wrong Type
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Missing Body
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Invalid Body Type
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Missing Body Items
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Missing Body Items
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Missing Body Items
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Missing Body Items
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Missing Body Items
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Missing Body Items
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Missing Body Items
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Invalid ID Type
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)
        # Invalid ID Type
        with self.assertRaises(InvalidMessageException):
            await receive_msg(self.socket)

        chatting_id, proxy_id, msg = await receive_msg(self.socket)
        self.assertEqual(chatting_id, self.chatting_id)
        self.assertEqual(proxy_id, self.proxy_id)
        self.assertEqual(msg, self.msg)
