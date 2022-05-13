from ..rater import (Element, Canvas, get_rater)
from .models import (MetricGroup, RatingResponse)
from flask import (Blueprint, request, jsonify, abort)

bp = Blueprint('rating', __name__, url_prefix='/rating')


@bp.route('', methods=['POST'])
def rate():
    # Request form validation
    content = request.get_json()
    canvas_json = content.get('canvas')
    items_json = content.get('items')
    if canvas_json is None or items_json is None:
        abort(400)
    # Decoding request JSON
    canvas = Canvas.from_json(canvas_json)
    elements = []
    for item_json in items_json:
        elements.append(Element.from_json(item_json))
    # Partial results
    ratings: list[MetricGroup] = list()
    rating_results = 0
    # Computing ratings
    raters = ['balance', 'equilibrium', 'symmetry', 'harmony']
    for rater_type in raters:
        rater_res = get_rater(rater_type, elements, canvas).rate()
        # Saving rating results
        partial_result = 0
        for res in rater_res:
            partial_result += res.rating
        rating_results += int(partial_result / len(rater_res))
        ratings.append(MetricGroup(rater_type, rater_res))
    # Sending response
    response = RatingResponse(int(rating_results/len(raters)), ratings)
    return jsonify(response.serialize())
