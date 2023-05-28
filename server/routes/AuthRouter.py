from flask import Blueprint

from controllers.AuthController import AuthController
AuthRouter = Blueprint('AuthRouter', __name__)

AuthRouter.route('/login', methods=['POST'])(AuthController.login)
AuthRouter.route('/register', methods=['POST'])(AuthController.register)

