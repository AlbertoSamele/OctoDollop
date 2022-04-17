from .rater import Rater
from .models import Rating
from .constants import MAX_SCORE
from typing import Final


class BalanceRater(Rater):

    __h_balance_id: Final[str] = 'balance_horizontal'
    __v_balance_id: Final[str] = 'balance_vertical'

    def rate(self) -> list[Rating]:
        # Weights
        w_left = 0.0
        w_right = 0.0
        w_top = 0.0
        w_bottom = 0.0
        # Computing
        for element in self._elements:
            # Updating horizontal weight
            h_weight = element.area(self._canvas) * (element.x_midpoint(self._canvas) - self._canvas.x_midpoint)
            if h_weight > 0:
                w_right += h_weight
            else:
                w_left += abs(h_weight)
            # Updating vertical weight
            v_weight = element.area(self._canvas) * (element.y_midpoint(self._canvas) - self._canvas.y_midpoint)
            if v_weight > 0:
                w_top += v_weight
            else:
                w_bottom += abs(v_weight)
        # Results
        norm_h_score = (w_left - w_right)/max(w_left, w_right)
        norm_v_score = (w_top - w_bottom) / max(w_top, w_bottom)
        h_score_hr = int(MAX_SCORE * (1 - abs(norm_h_score)))
        v_score_hr = int(MAX_SCORE * (1 - abs(norm_v_score)))
        msg_h_suffix = 'left' if norm_h_score < 0 else 'right'
        msg_v_suffix = 'top' if norm_v_score < 0 else 'bottom'

        return [
            Rating(self.__h_balance_id, h_score_hr, self.get_message(h_score_hr, msg_h_suffix)),
            Rating(self.__v_balance_id, v_score_hr, self.get_message(v_score_hr, msg_v_suffix))
        ]

    def get_message(self, score: int, direction: str) -> str:
        """
        Generates a human readable message for the given score

        Parameters:
        -----------
        score : int
            The raw score from which the message will be extrapolated
        direction : str
            The direction the balance leans towards

        Returns:
        --------
        str
            The human readable message
        """
        if score <= 30:
            return f'Too heavy on the {direction}'
        elif score <= 50:
            return f'Heavy on the {direction}'
        elif score <= 70:
            return f'Slightly heavy on the {direction}'
        elif score <= 80:
            return f'Good balance, slightly {direction}-heavy'
        else:
            return 'Excellent balance!'
