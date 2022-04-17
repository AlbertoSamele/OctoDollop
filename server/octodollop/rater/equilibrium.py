from .rater import Rater
from .models import Rating
from .constants import MAX_SCORE


class EquilibriumRater(Rater):

    __h_equilibrium_id = 'equilibrium_horizontal'
    __v_equilibrium_id = 'equilibrium_vertical'

    def rate(self) -> list[Rating]:
        # Weights
        areas_sum = 0.0
        h_sum = 0.0
        v_sum = 0.0
        # Computing
        for element in self._elements:
            areas_sum += element.area(self._canvas)
            h_sum += element.area(self._canvas) * element.x_midpoint(self._canvas)
            v_sum += element.area(self._canvas) * element.y_midpoint(self._canvas)
        # Partial result
        layout_center_x = h_sum / areas_sum
        layout_center_y = v_sum / areas_sum
        # Result
        norm_h_score = (self._canvas.x_midpoint - layout_center_x) / max(self._canvas.x_midpoint, layout_center_x)
        norm_v_score = (self._canvas.y_midpoint - layout_center_y) / max(self._canvas.y_midpoint, layout_center_y)
        h_score_hr = int(MAX_SCORE * (1 - abs(norm_h_score)))
        v_score_hr = int(MAX_SCORE * (1 - abs(norm_v_score)))
        msg_h_suffix = 'left' if norm_h_score > 0 else 'right'
        msg_v_suffix = 'top' if norm_v_score > 0 else 'bottom'
        return [Rating(self.__h_equilibrium_id, h_score_hr, self.get_message(h_score_hr, msg_h_suffix)),
                Rating(self.__v_equilibrium_id, v_score_hr, self.get_message(v_score_hr, msg_v_suffix))]

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
            return f'Heavy disequilibrium towards the {direction}'
        elif score <= 58:
            return f'Visible disequilibrium towards the {direction}'
        elif score <= 70:
            return f'Slight disequilibrium towards the {direction}'
        elif score <= 80:
            return f'Overall good equilibirum, slighly {direction}-leaning'
        else:
            return 'Great equilibrium!'
