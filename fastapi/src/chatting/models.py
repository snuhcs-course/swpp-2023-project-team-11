from datetime import datetime

from sqlalchemy import Boolean, Integer, String, Column, ForeignKey, Table, DateTime
from sqlalchemy.orm import Mapped, relationship

from src.database import Base
from src.user.models import User


class Chatting(Base):
    __tablename__ = "chatting"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    initiator_id: Mapped[int] = Column(ForeignKey("users.user_id"))
    responser_id: Mapped[int] = Column(ForeignKey("users.user_id"))
    is_approved: Mapped[bool] = Column(Boolean, nullable=False, default=False)
    is_terminated: Mapped[bool] = Column(Boolean, nullable=False, default=False)
    created_at: Mapped[datetime] = Column(DateTime, nullable=False)

    initiator: Mapped[User] = relationship(foreign_keys=[initiator_id])
    responser: Mapped[User] = relationship(foreign_keys=[responser_id])


class Text(Base):
    __tablename__ = "text"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    chatting_id: Mapped[int] = Column(ForeignKey("chatting.id"), nullable=False)
    sender_id: Mapped[int] = Column(ForeignKey("users.user_id"), nullable=False)
    msg: Mapped[str] = Column(String, nullable=False)
    timestamp: Mapped[datetime] = Column(DateTime, nullable=False)

    chatting: Mapped[Chatting] = relationship()
    sender: Mapped[User] = relationship()
