from ..opencv import get_bb
from flask import (Blueprint, request, current_app, jsonify, abort)
from werkzeug.utils import secure_filename
import os

bp = Blueprint('ai', __name__, url_prefix='/ai')


@bp.route('/bounding_boxes', methods=['POST'])
def get_bounding_boxes():
    # Parsing request files
    image = request.files.get('image')
    if image is None or not allowed_file(image.filename):
        abort(400)
    # Saving request files
    filename = secure_filename(image.filename)
    filepath = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
    image.save(filepath)
    # Processing request
    items = get_bb(filepath)
    # Clean up
    os.remove(filepath)
    # Response
    return jsonify(items)


def allowed_file(filename: str) -> bool:
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ['png', 'jpg', 'jpeg']