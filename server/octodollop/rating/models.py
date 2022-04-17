from ..rater import Rating
from typing import Final


class MetricGroup:

    def __init__(self, id_: str, ratings: list[Rating]):
        """
        Bundles ratings relative to the same semantic category

        Parameters:
        -----------
        id_ : str
            The ratings category id
        ratings : list[Rating]
            The ratings to be bundled
        """
        self.section: Final[str] = id_
        self.metrics: Final[list[Rating]] = ratings

    def serialize(self) -> dict:
        """
        Returns:
        --------
        dict
            The JSON serialized object
        """
        metrics_json: list[dict] = list()
        for metric in self.metrics:
            metrics_json.append(metric.serialize())
        return {
            'section': self.section,
            'metrics': metrics_json
        }


class RatingResponse:

    def __init__(self, score: int, ratings: list[MetricGroup]):
        """
        Response to ratings requests

        Parameters:
        -----------
        score : int
            The overall achieved rating score
        ratings : list[MetricGroup]
            The various ratings taken into account when computing the score
        """
        self.score: Final[int] = score
        self.metrics: Final[list[MetricGroup]] = ratings

    def serialize(self) -> dict:
        """
        Returns:
        --------
        dict
            The JSON serialized object
        """
        metrics_json: list[dict] = list()
        for metric in self.metrics:
            metrics_json.append(metric.serialize())
        return {
            'score': self.score,
            'metrics': metrics_json
        }
