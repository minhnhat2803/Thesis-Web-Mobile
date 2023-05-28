
from routes.BillRouter import BillRouter
from routes.UserRouter import UserRouter
from routes.AIRouter import AIRouter
from routes.AuthRouter import AuthRouter

class Router:
  def run(app):
    app.register_blueprint(BillRouter, url_prefix='/bills')
    app.register_blueprint(UserRouter, url_prefix='/users')
    app.register_blueprint(AIRouter, url_prefix='/scan')
    app.register_blueprint(AuthRouter, url_prefix='/auth')