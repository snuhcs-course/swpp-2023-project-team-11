import unittest
from unittest.mock import AsyncMock

from src.auth.models import Session
from src.database import DbConnector
from src.websocket.dependencies import *
from src.websocket.service import *
from tests.utils import *


class TestWebSocketManager(unittest.IsolatedAsyncioTestCase):
    manager = get_socket_manager()
    user_id = 1
    session_key1 = 'h'
    session_key2 = 'y'

    def setUp(self) -> None:
        self.socket1 = AsyncMock()
        self.socket2 = AsyncMock()
        self.socket3 = AsyncMock()

    async def test_add_socket(self):
        await self.manager.add_socket(self.user_id, self.session_key1, self.socket1)
        self.socket1.close.assert_not_called()
        self.assertEqual({self.socket1}, set(await self.manager.get_sockets([self.user_id])))

        await self.manager.add_socket(self.user_id, self.session_key2, self.socket2)
        self.socket1.close.assert_not_called()
        self.assertEqual({self.socket1, self.socket2}, set(await self.manager.get_sockets([self.user_id])))

        await self.manager.add_socket(self.user_id, self.session_key1, self.socket3)
        self.socket1.close.assert_called()
        self.assertEqual({self.socket2, self.socket3}, set(await self.manager.get_sockets([self.user_id])))

    async def test_remove_socket(self):
        await self.manager.add_socket(self.user_id, self.session_key1, self.socket1)
        await self.manager.add_socket(self.user_id, self.session_key2, self.socket2)
        
        await self.manager.remove_socket(self.user_id, self.session_key2, self.socket3)
        self.assertEqual({self.socket1, self.socket2}, set(await self.manager.get_sockets([self.user_id])))

        await self.manager.remove_socket(self.user_id, self.session_key2, self.socket2)
        self.assertEqual({self.socket1}, set(await self.manager.get_sockets([self.user_id])))

        await self.manager.remove_socket(self.user_id, self.session_key2, self.socket2)
        self.assertEqual({self.socket1}, set(await self.manager.get_sockets([self.user_id])))


class TestService(unittest.IsolatedAsyncioTestCase):
    email = "test@snu.ac.kr"
    session_key = "session_key"

    @classmethod
    def setUpClass(cls) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            cls.profile_id = setup_user(db, cls.email)
            db.execute(insert(Session).values({
                "session_key": cls.session_key,
                "user_id": cls.profile_id,
            }))
            db.commit()

    @classmethod
    @inject_db
    def tearDownClass(cls, db: DbSession) -> None:
        teardown_user(db)
        db.commit()

    @inject_db
    def setUp(self, db: DbSession) -> None:
        self.valid_chatting_id = db.scalar(insert(Chatting).values({
            "initiator_id": self.profile_id,
            "responder_id": self.profile_id,
            "is_approved": True,
            "created_at": datetime.now(),
        }).returning(Chatting.id))
        self.pending_chatting_id = db.scalar(insert(Chatting).values({
            "initiator_id": self.profile_id,
            "responder_id": self.profile_id,
            "created_at": datetime.now(),
        }).returning(Chatting.id))
        self.terminated_chatting_id = db.scalar(insert(Chatting).values({
            "initiator_id": self.profile_id,
            "responder_id": self.profile_id,
            "is_terminated": True,
            "created_at": datetime.now(),
        }).returning(Chatting.id))
        db.commit()

    async def asyncSetUp(self) -> None:
        self.socket = AsyncMock()
        self.recv_socket = AsyncMock()
        self.manager = WebSocketManager()
        await self.manager.add_socket(self.profile_id, self.session_key, self.recv_socket)

    def tearDown(self) -> None:
        for db in DbConnector.get_db():
            db.execute(delete(Text))
            db.execute(delete(Chatting))
            db.commit()

    async def test_authenticate_socket_valid_msg(self):
        self.socket.receive_json = AsyncMock(return_value={
            "type": "system",
            "body": {
                "session_key": self.session_key,
            }
        })

        session_key = (await authenticate_socket(self.socket))[1]
        self.assertEqual(session_key, self.session_key)
    
    async def test_authenticate_socket_no_type_msg(self):
        self.socket.receive_json = AsyncMock(return_value={
            "body": {
                "session_key": self.session_key,
            }
        })

        self.socket.close.assert_not_called()
        with self.assertRaises(WebSocketDisconnect):
            await authenticate_socket(self.socket)
        self.socket.close.assert_called()

    async def test_authenticate_socket_invalid_type_msg(self):
        self.socket.receive_json = AsyncMock(return_value={
            "type": "foo",
            "body": {
                "session_key": self.session_key,
            }
        })

        self.socket.close.assert_not_called()
        with self.assertRaises(WebSocketDisconnect):
            await authenticate_socket(self.socket)
        self.socket.close.assert_called()

    async def test_authenticate_socket_no_body_msg(self):
        self.socket.receive_json = AsyncMock(return_value={
            "type": "system",
        })

        self.socket.close.assert_not_called()
        with self.assertRaises(WebSocketDisconnect):
            await authenticate_socket(self.socket)
        self.socket.close.assert_called()

    async def test_authenticate_socket_invalid_body_msg(self):
        self.socket.receive_json = AsyncMock(return_value={
            "type": "system",
            "body": 3,
        })

        self.socket.close.assert_not_called()
        with self.assertRaises(WebSocketDisconnect):
            await authenticate_socket(self.socket)
        self.socket.close.assert_called()

    async def test_authenticate_socket_no_session_key_msg(self):
        self.socket.receive_json = AsyncMock(return_value={
            "type": "system",
            "body": {},
        })

        self.socket.close.assert_not_called()
        with self.assertRaises(WebSocketDisconnect):
            await authenticate_socket(self.socket)
        self.socket.close.assert_called()

    async def test_authenticate_socket_invalid_session_key_msg(self):
        self.socket.receive_json = AsyncMock(return_value={
            "type": "system",
            "body": {
                "session_key": "",
            },
        })

        self.socket.close.assert_not_called()
        with self.assertRaises(WebSocketDisconnect):
            await authenticate_socket(self.socket)
        self.socket.close.assert_called()

    async def test_handle_message_invalid_chatting_id(self):
        self.socket.send_json.assert_not_called()
        await handle_message(
            self.profile_id,
            {
                "type": "message",
                "body": {
                    "proxy_id": 0,
                    "chatting_id": -1,
                    "msg": ""
                }
            },
            self.socket, self.manager)
        self.socket.send_json.assert_called()
        self.recv_socket.close.assert_not_called()

    async def test_handle_message_invalid_user_id(self):
        self.socket.send_json.assert_not_called()
        await handle_message(
            -1,
            {
                "type": "message",
                "body": {
                    "proxy_id": 0,
                    "chatting_id": self.valid_chatting_id,
                    "msg": ""
                }
            },
            self.socket, self.manager)
        self.socket.send_json.assert_called()
        self.recv_socket.close.assert_not_called()

    async def test_handle_message_terminated(self):
        self.socket.send_json.assert_not_called()
        await handle_message(
            self.profile_id,
            {
                "type": "message",
                "body": {
                    "proxy_id": 0,
                    "chatting_id": self.terminated_chatting_id,
                    "msg": ""
                }
            },
            self.socket, self.manager)
        self.socket.send_json.assert_called()
        self.recv_socket.close.assert_not_called()

    async def test_handle_message_pending(self):
        self.socket.send_json.assert_not_called()
        await handle_message(
            self.profile_id,
            {
                "type": "message",
                "body": {
                    "proxy_id": 0,
                    "chatting_id": self.pending_chatting_id,
                    "msg": ""
                }
            },
            self.socket, self.manager)
        self.socket.send_json.assert_called()
        self.recv_socket.close.assert_not_called()

    async def test_handle_message_pending(self):
        self.socket.send_json.assert_not_called()
        await handle_message(
            self.profile_id,
            {
                "type": "message",
                "body": {
                    "proxy_id": 0,
                    "chatting_id": self.pending_chatting_id,
                    "msg": ""
                }
            },
            self.socket, self.manager)
        self.socket.send_json.assert_called()
        self.recv_socket.close.assert_not_called()

    async def test_handle_message_success(self):
        self.recv_socket.send_json.assert_not_called()
        await handle_message(
            self.profile_id,
            {
                "type": "message",
                "body": {
                    "proxy_id": 0,
                    "chatting_id": self.valid_chatting_id,
                    "msg": ""
                }
            },
            self.socket, self.manager)
        self.socket.close.assert_not_called()
        self.recv_socket.send_json.assert_called()

    async def test_parse_message(self):
        output = await parse_message({"body": {"proxy_id": 0, "chatting_id": 0, "msg": ""}}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "foo", "body": {"proxy_id": 0, "chatting_id": 0, "msg": ""}}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message"}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message", "body": 3}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message", "body": {}}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message", "body": {"chatting_id": 0}}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message", "body": {"proxy_id": 0}}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message", "body": {"msg": ""}}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message", "body": {"chatting_id": 0, "proxy_id": 0}}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message", "body": {"proxy_id": 0, "msg": ""}}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message", "body": {"chatting_id": 0, "msg": ""}}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message", "body": {"proxy_id": 0, "chatting_id": "a", "msg": ""}}, self.socket)
        self.assertIsNone(output)
        output = await parse_message({"type": "message", "body": {"proxy_id": "a", "chatting_id": 0, "msg": ""}}, self.socket)
        self.assertIsNone(output)
        proxy_id, chatting_id, msg = await parse_message({"type": "message", "body": {"proxy_id": 0, "chatting_id": 0, "msg": ""}}, self.socket)
        self.assertEqual(proxy_id, 0)
        self.assertEqual(chatting_id, 0)
        self.assertEqual(msg, "")
