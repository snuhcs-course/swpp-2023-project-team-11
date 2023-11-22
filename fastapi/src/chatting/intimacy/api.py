from __future__ import annotations
from abc import ABCMeta, abstractmethod
import json
from typing import Dict

from requests import Response, post


class ApiCaller(metaclass=ABCMeta):
    """An interface for external API caller."""

    @property
    @abstractmethod
    def api_url(self) -> str:
        """URL for API calls."""

    @property
    @abstractmethod
    def headers(self) -> Dict[str, str]:
        """Required(or additional) headers for request."""

    @abstractmethod
    def data(self, text: str) -> Dict[str, str]:
        """A request data(body)."""

    @abstractmethod
    def request(self, text: str) -> Response:
        """Sends an external API request."""


class PapagoApiCaller(ApiCaller):
    API_URL: str = "https://naveropenapi.apigw.ntruss.com/nmt/v1/translation"

    def __init__(self, client_id: str, client_secret: str) -> None:
        self.__client_id = client_id
        self.__client_secret = client_secret

    @property
    def api_url(self) -> str:
        return self.API_URL

    @property
    def headers(self) -> Dict[str, str]:
        return {
            "X-NCP-APIGW-API-KEY-ID": self.__client_id,
            "X-NCP-APIGW-API-KEY": self.__client_secret,
        }

    def data(self, text: str) -> Dict[str, str]:
        if len(text) > 999:
            text = text[:999]
        return {"source": "auto", "target": "ko", "text": text}

    def request(self, text: str) -> Response:
        data = self.data(text)
        return post(self.api_url, data=data, headers=self.headers)


class ClovaApiCaller(ApiCaller):
    API_URL: str = "https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze"

    def __init__(self, client_id: str, client_secret: str) -> None:
        self.__client_id = client_id
        self.__client_secret = client_secret

    @property
    def api_url(self) -> str:
        return self.API_URL

    @property
    def headers(self) -> Dict[str, str]:
        return {
            "X-NCP-APIGW-API-KEY-ID": self.__client_id,
            "X-NCP-APIGW-API-KEY": self.__client_secret,
            "Content-Type": "application/json",
        }

    def data(self, text: str) -> Dict[str, str]:
        return {"content": text}

    def request(self, text: str) -> Response:
        data = self.data(text)
        return post(self.api_url, data=json.dumps(data), headers=self.headers)
