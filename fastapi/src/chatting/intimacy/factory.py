from __future__ import annotations
from abc import ABCMeta, abstractmethod

from src.chatting.exceptions import *
from src.chatting.intimacy.api import *
from src.chatting.intimacy.handler import *
from src.chatting.intimacy.parser import *
from src.chatting.intimacy.service import *


class TextServiceFactory(metaclass=ABCMeta):
    """
    An interface of text service factory with abstract factory pattern
    which creates caller, handler and parser based on service type,
    and service which is a facade of all the others.
    """

    @abstractmethod
    def create_caller(self) -> ApiCaller:
        """Creates an API caller that sends request to the external service."""

    @abstractmethod
    def create_handler(self) -> ErrorHandler:
        """Creates an error handler that detects erroneous response."""

    @abstractmethod
    def create_parser(self) -> Parser:
        """Creates a parser that parses the response."""

    @abstractmethod
    def create_service(self) -> TextService:
        """Creates a text service facade."""


class BaseTextServiceFactory(TextServiceFactory):
    """An abstract class which creates a base text service."""

    def create_service(self) -> TextService:
        caller = self.create_caller()
        handler = self.create_handler()
        parser = self.create_parser()
        return BaseTextService(caller, handler, parser)


class PapagoServiceFactory(BaseTextServiceFactory):
    def __init__(self, client_id: str, client_secret: str):
        self.client_id = client_id
        self.client_secret = client_secret

    def create_caller(self) -> ApiCaller:
        return PapagoApiCaller(self.client_id, self.client_secret)

    def create_handler(self) -> ErrorHandler:
        return NotOkHandler(PapagoApiException)

    def create_parser(self) -> Parser:
        return PapagoParser()


class ClovaServiceFactory(BaseTextServiceFactory):
    def __init__(self, client_id: str, client_secret: str):
        self.client_id = client_id
        self.client_secret = client_secret

    def create_caller(self) -> ApiCaller:
        return ClovaApiCaller(self.client_id, self.client_secret)

    def create_handler(self) -> ErrorHandler:
        return NotOkHandler(ClovaApiException)

    def create_parser(self) -> Parser:
        return ClovaParser()


class KoreanDetetionPapagoServiceFactory(PapagoServiceFactory):
    def create_handler(self) -> ErrorHandler:
        return super().create_handler().set_front(KoreanDetectionPapagoHandler())
