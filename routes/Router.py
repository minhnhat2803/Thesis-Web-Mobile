
from routes.UserRouter import UserRouter
from routes.AIRouter import AIRouter

class Router:
  def run(app):
    app.register_blueprint(UserRouter, url_prefix='/users')
    app.register_blueprint(AIRouter, url_prefix='/scan')