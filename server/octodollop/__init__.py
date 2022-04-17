import os
from flask import (Flask, request)


def create_app():
    app = Flask(__name__)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # Rating
    from .rating import rating
    app.register_blueprint(rating.bp)

    return app
