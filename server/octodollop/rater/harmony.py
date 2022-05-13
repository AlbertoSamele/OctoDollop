from .rater import Rater
from .models import Rating
from .constants import MAX_SCORE
import statistics as stat


class HarmonyRater(Rater):

    __density_harmony_id = 'harmony_density'
    __proportion_harmony_id = 'harmony_proportion'

    def rate(self) -> list[Rating]:
        denisty_rating = self.rate_denisty()
        simplicity_rating = self.rate_proportion()
        return [denisty_rating, simplicity_rating]

    def rate_denisty(self) -> Rating:
        """
        Returns:
        --------
        Rating
            The rating for the density metric
        """
        # Computing
        canvas_area = self._canvas.width * self._canvas.height
        el_areas = [element.area(self._canvas) for element in self._elements]
        # Result
        score = sum(el_areas) / canvas_area
        score_hr = int(MAX_SCORE * (1 - abs(score - 0.65) / 0.65))
        msg = ''
        if 0 <= score <= 0.35:
            msg = 'The screen doesn\'t have enough content'
        elif 0.35 < score <= 0.70:
            msg = 'The screen space is well used'
        else:
            msg = 'The screen appears too cluttered'
        return Rating(self.__density_harmony_id, score_hr, msg)

    def rate_proportion(self) -> Rating:
        """
        Returns:
        --------
        Rating
            The rating for the proportion metric
        """
        # Computing
        proportions = [(el.width / el.height) for el in self._elements]
        similarity = []
        for i1, p1 in enumerate(proportions):
            for i2, p2 in enumerate(proportions):
                if i1 == i2:
                    continue
                similarity.append((abs(p1 - p2)/max(p1, p2)))
        # Results
        score = 1 - sum(similarity)/len(similarity)
        score_hr = int(MAX_SCORE * score)
        msg = ''
        if 0 <= score_hr <= 35:
            msg = 'The shape of your elements differs greatly'
        elif 35 < score_hr <= 55:
            msg = 'The elements are not entirely homogeneous'
        elif 55 < score_hr <= 75:
            msg = 'The elements are consistently shaped'
        else:
            msg = 'The elements proportions are excellent!'
        return Rating(self.__proportion_harmony_id, score_hr, msg)
