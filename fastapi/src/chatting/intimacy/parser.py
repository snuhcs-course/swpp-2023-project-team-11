from __future__ import annotations
from abc import ABCMeta, abstractmethod
from typing import Any

from requests import Response


class Parser(metaclass=ABCMeta):
    """An interface for response parser."""

    @abstractmethod
    def parse(self, response: Response) -> Any:
        """Parses response."""


class BaseParser(Parser):
    """An abstract client with default behavior which returns the whole dictionary"""

    @abstractmethod
    def parse(self, response: Response) -> Any:
        return response.json()


class PapagoParser(BaseParser):
    """Parses papago response."""

    def parse(self, response: Response) -> Any:
        data = super().parse(response)
        return data["message"]["result"]["translatedText"]


class ClovaParser(BaseParser):
    """Parses clova response."""

    def parse(self, response: Response) -> Any:
        data = super().parse(response)
        positive = data["document"]["confidence"]["positive"]
        negative = data["document"]["confidence"]["negative"]
        result = positive - negative
        if result >= 0:
            return result * 0.1
        else:
            return result * 0.05
        # positive[0~100] negative[0~100]
