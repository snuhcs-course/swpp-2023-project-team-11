from __future__ import annotations
from abc import ABCMeta, abstractmethod
from typing import Any, Callable

from src.chatting.intimacy.api import ApiCaller
from src.chatting.intimacy.handler import ErrorHandler
from src.chatting.intimacy.parser import Parser
from src.exceptions import ExternalApiError


class TextService(metaclass=ABCMeta):
    """An interface of text related service."""

    @abstractmethod
    def call(self, text: str) -> Any:
        """Calls the service and return response"""


class TextServiceWithFallback(TextService):
    """An abstract class which has a default value of response."""

    def __init__(self, fallback: Callable[[str], Any]):
        self.__fallback = fallback

    @property
    def fallback(self) -> Callable[[str], Any]:
        return self.__fallback


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


class IgnoresEmptyTextService(TextServiceWithFallback):
    """
    A proxy of text service with proxy pattern
    which ignores an empty text before calling the text service.
    """

    def __init__(self, service: TextService, fallback: Callable[[str], Any]):
        super().__init__(fallback)
        self.__service = service

    def call(self, text: str) -> Any:
        if len(text) == 0:
            return self.fallback(text)

        return self.__service.call(text)


class SuppressErrorTextService(TextServiceWithFallback):
    """
    A proxy of text service with proxy pattern
    which suppresses all errors raised by handler and calls fallback.
    """

    def __init__(self, service: TextService, fallback: Callable[[str], Any]):
        super().__init__(fallback)
        self.__service = service

    def call(self, text: str) -> Any:
        try:
            return self.__service.call(text)
        except ExternalApiError:
            return self.fallback(text)
