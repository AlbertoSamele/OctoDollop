import os
from flask import (Flask, request)


def create_app():
    app = Flask(__name__)
    app.config['UPLOAD_FOLDER'] = os.path.join(app.instance_path, 'uploads')

    # ensure the instance folder exists
    try:
        os.makedirs(os.path.join(app.instance_path, 'uploads'))
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # Rating
    from .rating import views as r_views
    app.register_blueprint(r_views.bp)
    # AI processing
    from .ai import views as ai_views
    app.register_blueprint(ai_views.bp)

    return app
