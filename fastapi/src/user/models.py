from sqlalchemy import Column, Integer, String, BigInteger

from src.database import Base


class Email(Base):
    __tablename__ = "email"

    email = Column(String, nullable=False, unique=True)
    email_id = Column(BigInteger, primary_key=True)


class EmailCode(Base):
    __tablename__ = "email_code"

    email_id = Column(BigInteger, nullable=False, unique=True, ForeignKey=Email.email_id)
    code = Column(Integer, nullable=False)


class VerifiedEmail(Base):
    __tablename__ = "verified_email"

    email_id = Column(BigInteger, nullable=False, unique=True, ForeignKey=Email.email_id)
    verification_id = Column(BigInteger, primary_key=True)
