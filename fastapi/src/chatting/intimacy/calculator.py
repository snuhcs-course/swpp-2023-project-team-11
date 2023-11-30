from typing import List

import numpy as np

from src.chatting.intimacy.service import TextService
from src.chatting.models import *
from src.chatting.constants import *

class IntimacyCalculator:
    """A facade pattern which calls translation text service and sentiment text service."""

    def __init__(self, translation: TextService, sentiment: TextService) -> None:
        self.__translation = translation
        self.__sentiment = sentiment

    def calculate(
        self,
        user_id: int,
        curr_texts: List[Text],
        prev_texts: List[Text],
        recent_intimacy: Intimacy,
        similarity: float | None = None,
        num_F: int | None = None,
    ) -> float:
        
        curr_translated = self.__translation.call('.'.join(text.msg for text in curr_texts))
        sentiment = self.__sentiment.call(curr_translated)

        frequency = self.score_frequency(curr_texts)
        frequency_delta = self.score_frequency_delta(prev_texts, curr_texts)
        length = self.score_avg_length(curr_texts)
        length_delta = self.score_avg_length_delta(prev_texts, curr_texts)
        turn = self.score_turn(curr_texts, user_id)
        turn_delta = self.score_turn_delta(prev_texts, curr_texts, user_id)
        params = np.array([sentiment, frequency, frequency_delta,
                          length, length_delta, turn, turn_delta])

        weight = self.get_weight(similarity, num_F)
        intimacy_delta = weight.dot(params.transpose())
        # alpha's range: 1/3 ~ 3
        alpha = DEFAULT_INTIMACY/(recent_intimacy.intimacy + 12)
        if intimacy_delta < 0:
            alpha = (1 / alpha)
        new_intimacy: float = recent_intimacy.intimacy + intimacy_delta * alpha
        return max(0, min(100, new_intimacy))

    @staticmethod
    def null_if_empty(func):
        """Decorator pattern"""

        def wrapper(texts: List[Text], *args, **kwargs) -> float | None:
            if len(texts) == 0:
                return None

            return func(texts, *args, **kwargs)

        return wrapper

    @staticmethod
    def get_delta(prev: float | None, curr: float | None) -> float | None:
        if prev is None or curr is None:
            return None
        return curr - prev

    @staticmethod
    @null_if_empty
    def get_frequency(texts: List[Text]) -> float | None:
        """An average seconds for 20 texts"""

        frequency = datetime.now() - texts[-1].timestamp
        seconds = frequency.seconds + frequency.microseconds / 1e6
        return seconds * 20 / len(texts)

    @staticmethod
    def get_frequency_delta(prev_text: List[Text], curr_text: List[Text]) -> float | None:
        return IntimacyCalculator.get_delta(
            IntimacyCalculator.get_frequency(prev_text),
            IntimacyCalculator.get_frequency(curr_text))

    @staticmethod
    def score_frequency(texts: List[Text]) -> int:
        seconds = IntimacyCalculator.get_frequency(texts)
        if seconds is None:
            return 0

        if 3600 <= seconds:
            return -5
        elif 3000 <= seconds:
            return -4
        elif 2400 <= seconds:
            return -2
        elif 1800 <= seconds:
            return 0
        elif 1200 <= seconds:
            return 3
        elif 600 <= seconds:
            return 5
        else:
            return 10

    @staticmethod
    def score_frequency_delta(prev_texts: List[Text], curr_texts: List[Text]) -> int:
        seconds = IntimacyCalculator.get_frequency_delta(
            prev_texts, curr_texts)
        if seconds is None:
            return 0

        if 1800 <= seconds:
            return -5
        elif 1200 <= seconds:
            return -3
        elif 600 <= seconds:
            return -1
        elif -600 <= seconds:
            return 0
        elif -1200 <= seconds:
            return 3
        elif -1800 <= seconds:
            return 5
        else:
            return 10

    @staticmethod
    @null_if_empty
    def get_avg_length(texts: List[Text]) -> float | None:
        avg_len = 0
        for text in texts:
            avg_len += len(text.msg)
        avg_len /= len(texts)
        return avg_len

    @staticmethod
    def get_avg_length_delta(
        prev_texts: List[Text], curr_texts: List[Text]
    ) -> float | None:
        return IntimacyCalculator.get_delta(
            IntimacyCalculator.get_avg_length(prev_texts),
            IntimacyCalculator.get_avg_length(curr_texts))

    @staticmethod
    def score_avg_length(texts: List[Text]) -> int:
        avg_len = IntimacyCalculator.get_avg_length(texts)
        if avg_len is None:
            return 0

        if avg_len >= 30:
            return 10
        elif avg_len >= 20:
            return 7
        elif avg_len >= 10:
            return 4
        elif avg_len >= 5:
            return 0
        else:
            return -5

    @staticmethod
    def score_avg_length_delta(prev_texts: List[Text], curr_texts: List[Text]) -> int:
        avg_len = IntimacyCalculator.get_avg_length_delta(
            prev_texts, curr_texts)
        if avg_len is None:
            return 0

        if avg_len >= 15:
            return 10
        elif avg_len >= 10:
            return 5
        elif avg_len >= -10:
            return 0
        elif avg_len >= -20:
            return -3
        else:
            return -5

    # scope of rate[0,1]
    @staticmethod
    @null_if_empty
    def get_turn(texts: List[Text], user_id: int) -> float | None:
        """How many turns that the user took among provided texts"""

        turn = 0
        for text in texts:
            if text.sender_id == user_id:
                turn += 1

        rate = turn / len(texts)
        return rate

    # 작을수록 개선된 것(0.5에 가까워졌으므로)
    @staticmethod
    def get_turn_delta(
        prev_texts: List[Text], curr_texts: List[Text], user_id: int
    ) -> float | None:
        prev_rate = IntimacyCalculator.get_turn(prev_texts, user_id)
        curr_rate = IntimacyCalculator.get_turn(curr_texts, user_id)

        if prev_rate is None or curr_rate is None:
            return None

        return abs(curr_rate - 0.5) - abs(prev_rate - 0.5)

    @staticmethod
    def score_turn(texts: List[Text], user_id: int) -> int:
        rate = IntimacyCalculator.get_turn(texts, user_id)
        if rate is None:
            return 0

        if 0.4 <= rate <= 0.6:
            return 10
        elif 0.3 <= rate <= 0.7:
            return 5
        elif 0.2 <= rate <= 0.8:
            return 0
        elif 0.1 <= rate <= 0.9:
            return -3
        else:
            return -5

    @staticmethod
    def score_turn_delta(
        prev_texts: List[Text], curr_texts: List[Text], user_id: int
    ) -> int:
        rate = IntimacyCalculator.get_turn_delta(
            prev_texts, curr_texts, user_id)
        if rate is None:
            return 0

        if 0.3 <= rate:
            return -5
        elif 0.1 <= rate:
            return -3
        elif 0.0 <= rate:
            return 0
        else:
            return 10

    @staticmethod
    def get_weight(similarity: float | None = None, num_F: int | None = None) -> np.ndarray[float]:
        # Default
        if similarity is None or num_F is None:
            return np.array([0.1, 0.3, 0, 0.3, 0, 0.3, 0])

        if similarity < 0.2:
            # sentiment, frequency, frequency_delta, length, length_delta, turn, turn_delta
            weight = np.array([0.1, 0.2, 0.1, 0.2, 0.1, 0.2, 0.1])
        elif similarity < 0.4:
            weight = np.array([0.1, 0.19, 0.11, 0.19, 0.11, 0.19, 0.11])
        elif similarity < 0.6:
            weight = np.array([0.1, 0.18, 0.12, 0.18, 0.12, 0.18, 0.12])
        elif similarity < 0.8:
            weight = np.array([0.1, 0.17, 0.13, 0.17, 0.13, 0.17, 0.13])
        else:
            weight = np.array([0.1, 0.16, 0.14, 0.16, 0.14, 0.16, 0.14])

        if num_F == 0:
            weight[0] += 0.03
            for i in range(1, 7):
                weight[i] -= 0.005
        elif num_F == 1:
            weight[0] += 0.06
            for i in range(1, 7):
                weight[i] -= 0.01
        elif num_F == 2:
            weight[0] += 0.09
            for i in range(1, 7):
                weight[i] -= 0.015

        return weight
