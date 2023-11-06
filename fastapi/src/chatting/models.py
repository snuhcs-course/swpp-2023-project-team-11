from datetime import datetime

from sqlalchemy import Boolean, Integer, String, Column, ForeignKey, Table, DateTime, Float
from sqlalchemy.orm import Mapped, relationship

from src.database import Base
from src.user.models import User


class Chatting(Base):
    __tablename__ = "chatting"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    initiator_id: Mapped[int] = Column(ForeignKey("users.user_id"))
    responder_id: Mapped[int] = Column(ForeignKey("users.user_id"))
    is_approved: Mapped[bool] = Column(Boolean, nullable=False, default=False)
    is_terminated: Mapped[bool] = Column(Boolean, nullable=False, default=False)
    created_at: Mapped[datetime] = Column(DateTime, nullable=False)

    initiator: Mapped[User] = relationship(foreign_keys=[initiator_id])
    responser: Mapped[User] = relationship(foreign_keys=[responder_id])


class Text(Base):
    __tablename__ = "text"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    chatting_id: Mapped[int] = Column(ForeignKey("chatting.id"), nullable=False)
    sender_id: Mapped[int] = Column(ForeignKey("users.user_id"), nullable=False)
    msg: Mapped[str] = Column(String, nullable=False)
    timestamp: Mapped[datetime] = Column(DateTime, nullable=False)

    chatting: Mapped[Chatting] = relationship()
    sender: Mapped[User] = relationship()


class Intimacy(Base):
    __tablename__ = "user_intimacy"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = Column(ForeignKey("users.user_id"), nullable=False)
    chatting_id: Mapped[int] = Column(ForeignKey("chatting.id"), nullable=False)
    intimacy: Mapped[float] = Column(Float, nullable=False)
    # TODO alembic migration 추가
    timestamp: Mapped[datetime] = Column(DateTime, nullable=False)
    chatting: Mapped[Chatting] = relationship()
    user: Mapped[User] = relationship()


class Topic(Base):
    __tablename__ = "topic"
    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    topic: Mapped[str] = Column(String, nullable=False)
    tag: Mapped[str] = Column(String, nullable=False)
    #tag A = 제일 친함 / B = 친함 / C = 보통
