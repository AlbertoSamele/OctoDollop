from .balance import BalanceRater
from .equilibrium import EquilibriumRater
from .symmetry import SymmetryRater
from .rater import Rater
from .models import (Element, Canvas, Rating)
from typing import Final


def get_rater(value: str, elements: list[Element], canvas: Canvas) -> Rater:
    """
    Parameters:
    ----------
    value : str
        The rater type to be instantiated, either 'balance', 'equilibrium' or 'symmetry'
    elements : list[Element]
        The elements relative to the UI to be rated
    canvas : Canvas
        The canvas in which the elements belong to

    Returns:
    ------
    Rater
        The desired rater instance
    """
    if value not in __available_raters:
        raise ValueError(f'Rater {value} does not exist, choose between {__available_raters.keys()}')
    return __available_raters[value](elements=elements, canvas=canvas)


__available_raters: Final[dict[str:Rater]] = {
    'balance': BalanceRater,
    'equilibrium': EquilibriumRater,
    'symmetry': SymmetryRater
}
