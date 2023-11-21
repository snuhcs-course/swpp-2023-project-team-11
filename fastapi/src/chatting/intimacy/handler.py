from __future__ import annotations
from abc import ABCMeta, abstractmethod
from typing import Type

from fastapi import HTTPException
from requests import Response

from src.chatting.exceptions import KoreanTranslationException


class ErrorHandler(metaclass=ABCMeta):
    """
    Error handler interface which declares a method for building the chain of error handlers.
    It also declares a method for handling errors.
    """

    @abstractmethod
    def set_front(self, front: ErrorHandler) -> ErrorHandler:
        """Sets the front element of the chain."""

    @abstractmethod
    def set_next(self, next: ErrorHandler) -> ErrorHandler:
        """Sets the next element of the chain."""

    @abstractmethod
    def handle(self, response: Response) -> None:
        """Handle specific error in case of unexpected response."""


class BaseErrorHandler(ErrorHandler):
    """The default chaining and handling behavior."""

    _next: ErrorHandler = None

    def set_front(self, front: ErrorHandler) -> ErrorHandler:
        front.set_next(self)
        return front

    def set_next(self, next: ErrorHandler) -> ErrorHandler:
        self._next = next
        return next

    @abstractmethod
    def handle(self, response: Response) -> None:
        if self._next is not None:
            return self._next.handle(response)

        return None


class NotOkHandler(BaseErrorHandler):
    """An error handler which raises exception unless the status code is 200"""

    def __init__(self, exc: Type[HTTPException]) -> None:
        super().__init__()
        self.exc = exc

    def handle(self, response: Response) -> None:
        if response.status_code != 200:
            raise self.exc()
        else:
            return super().handle(response)


class KoreanDetectionPapagoHandler(BaseErrorHandler):
    """A CoR pattern that filters errors by korean input."""

    def handle(self, response: Response) -> None:
        data = response.json()
        if response.status_code == 400 and data.get('error') is not None and data['error'].get('errorCode') == 'N2MT05':
            raise KoreanTranslationException()
        else:
            return super().handle(response)
