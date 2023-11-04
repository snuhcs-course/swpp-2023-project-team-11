import unittest
from unittest.mock import patch
from src.chatting.service import get_translated_text


class TestChattingService(unittest.TestCase):
    @patch("requests.post")
    def test_get_translated_text(self, mock_post):
        mock_post.return_value.json.return_value = {
            "message": {
                "result": {
                    "translatedText": "안녕하세요",
                }
            }
        }
        
        
        translated_text = get_translated_text("Hello")
        self.assertEqual(translated_text, "안녕하세요")
