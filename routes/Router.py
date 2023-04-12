
from routes.UserRouter import UserRouter

class Router:
  def run(app):
    app.register_blueprint(UserRouter, url_prefix='/users')