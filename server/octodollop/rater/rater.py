from abc import (ABC, abstractmethod)
from typing import Final

from .models import (Element, Canvas, Rating)


class Rater(ABC):

    def __init__(self, canvas: Canvas, elements: list[Element]):
        """
        Parameters:
        -----------
        canvas : Canvas
            The canvas in which elements are contained in
        elements : list[Element]
            The elements whose features ought to be rated
        """
        self._canvas: Final[Canvas] = canvas
        self._elements: Final[list[Element]] = elements

    @abstractmethod
    def rate(self) -> list[Rating]:
        """
        Computes the rating(s) of the given elements

        Returns:
        ---------
        list[Rating]
            The target feature rating(s)
        """
        pass
