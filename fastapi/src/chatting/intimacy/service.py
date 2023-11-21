from __future__ import annotations
from abc import ABCMeta, abstractmethod
from typing import Any

from src.chatting.intimacy.api import ApiCaller
from src.chatting.intimacy.handler import ErrorHandler
from src.chatting.intimacy.parser import Parser
from src.exceptions import ExternalApiError


class TextService(metaclass=ABCMeta):
    """An interface of text related service."""

    @abstractmethod
    def call(self, text: str) -> Any:
        """Calls the service and return response"""


class TextServiceWithDefault(TextService):
    """An abstract class which has a default value of response."""

    def __init__(self, default: Any):
        self.__default = default

    @property
    def default(self) -> Any:
        return self.__default


class BaseTextService(TextService):
    """
    A default text service with facade pattern
    which calls an external API, handles errors and parses responses.
    """

    def __init__(self, caller: ApiCaller, handler: ErrorHandler, parser: Parser) -> None:
        self.caller = caller
        self.handler = handler
        self.parser = parser

    def call(self, text: str) -> Any:
        response = self.caller.request(text)
        self.handler.handle(response)
        return self.parser.parse(response)


class IgnoresEmptyTextService(TextServiceWithDefault):
    """
    A proxy of text service with proxy pattern
    which ignores an empty text before calling the text service.
    """

    def __init__(self, service: TextService, default: Any):
        super().__init__(default)
        self.__service = service

    def call(self, text: str) -> Any:
        if len(text) == 0:
            return self.default

        return self.__service.call(text)


class SuppressErrorTextService(TextServiceWithDefault):
    """
    A proxy of text service with proxy pattern
    which suppresses all errors raised by handler and returns default.
    """

    def __init__(self, service: TextService, default: Any):
        super().__init__(default)
        self.__service = service

    def call(self, text: str) -> Any:
        try:
            return self.__service.call(text)
        except ExternalApiError:
            return self.default
