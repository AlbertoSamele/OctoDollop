from .rater import Rater
from .models import (Rating, Element)
from .constants import MAX_SCORE


class SymmetryRater(Rater):

    __h_symmetry_id = 'symmetry_horizontal'
    __v_symmetry_id = 'symmetry_vertical'
    __r_symmetry_id = 'symmetry_radial'

    def rate(self) -> list[Rating]:
        # Weights
        w_top_left: dict[str, float] = {'x': 0.0, 'y': 0.0, 'w': 0.0, 'h': 0.0}
        w_top_right = {'x': 0.0, 'y': 0.0, 'w': 0.0, 'h': 0.0}
        w_bottom_left = {'x': 0.0, 'y': 0.0, 'w': 0.0, 'h': 0.0}
        w_bottom_right = {'x': 0.0, 'y': 0.0, 'w': 0.0, 'h': 0.0}
        # Computing
        for element in self._elements:
            x_midpoint = element.x_midpoint(self._canvas)
            y_midpoint = element.y_midpoint(self._canvas)
            # Top left
            if x_midpoint <= self._canvas.x_midpoint and y_midpoint <= self._canvas.y_midpoint:
                self.__update_weights(w_top_left, element)
            # Top right
            elif x_midpoint >= self._canvas.x_midpoint and y_midpoint <= self._canvas.y_midpoint:
                self.__update_weights(w_top_right, element)
            # Bottom left
            if x_midpoint <= self._canvas.x_midpoint and y_midpoint >= self._canvas.y_midpoint:
                self.__update_weights(w_bottom_left, element)
            # Bottom right
            if x_midpoint >= self._canvas.x_midpoint and y_midpoint >= self._canvas.y_midpoint:
                self.__update_weights(w_bottom_right, element)
        # Results
        v_top = self.__diff(w_top_left, w_top_right)
        v_bottom = self.__diff(w_bottom_left, w_bottom_right)
        v_hr = int(MAX_SCORE * (v_top + v_bottom) / 2)
        h_left = self.__diff(w_top_left, w_bottom_left)
        h_right = self.__diff(w_top_right, w_bottom_right)
        h_hr = int(MAX_SCORE * (h_left + h_right) / 2)
        ratings: list[Rating] = [
            Rating(self.__v_symmetry_id, v_hr, self.get_message(v_hr)),
            Rating(self.__h_symmetry_id, h_hr, self.get_message(h_hr)),
        ]
        return ratings

    def __update_weights(self, weights: dict[str, float], element: Element):
        """
        Updates the weights accounting with the new element's data

        Parameters:
        -----------
        weights : dict[str, float]
            The weights to be updated. Convention: 'x', 'y', 'w', 'h' weight keys
        element : Element
            The element used to update the weights
        """
        weights['x'] += abs(element.x_midpoint(self._canvas) - self._canvas.x_midpoint)
        weights['y'] += abs(element.y_midpoint(self._canvas) - self._canvas.y_midpoint)
        weights['w'] += element.absolute_width(self._canvas)
        weights['h'] += element.absolute_height(self._canvas)

    def __diff(self, w1: dict[str, float], w2: dict[str, float]) -> float:
        """
        Relative difference of two weights

        Parameters:
        -----------
        w1 : dict[str, float]
            Weights minuend. Convention: 'x', 'y', 'w', 'h' weight keys
        w2 : Element
            Weights subtrahend. Convention: 'x', 'y', 'w', 'h' weight keys

        Returns:
        --------
        float
            The normalized difference of the two weight
        """
        max_x = max(w1['x'], w2['x']) if max(w1['x'], w2['x']) != 0 else 1
        max_y = max(w1['y'], w2['y']) if max(w1['y'], w2['y']) != 0 else 1
        max_w = max(w1['w'], w2['w']) if max(w1['w'], w2['w']) != 0 else 1
        max_h = max(w1['h'], w2['h']) if max(w1['h'], w2['h']) != 0 else 1
        diff_x = (w1['x'] - w2['x']) / max_x
        diff_y = (w1['y'] - w2['y']) / max_y
        diff_w = (w1['w'] - w2['w']) / max_w
        diff_h = (w1['h'] - w2['h']) / max_h
        return (diff_x + diff_y + diff_w + diff_h) / 4

    def get_message(self, score: int) -> str:
        """
        Generates a human readable message for the given score

        Parameters:
        -----------
        score : int
            The raw score from which the message will be extrapolated

        Returns:
        --------
        str
            The human readable message
        """
        if score <= 30:
            return 'Significant asymmetry in the layout'
        elif score <= 50:
            return 'Noticeable asymmetry in the layout'
        elif score <= 70:
            return 'Overall decent symmetry'
        elif score <= 80:
            return 'Very good symmetry'
        else:
            return 'Superb symmetry!'
