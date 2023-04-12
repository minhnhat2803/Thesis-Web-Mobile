from flask import Blueprint

from controllers.AIController import AIController
AIRouter = Blueprint('AIRouter', __name__)

AIRouter.route('/', methods=['GET'])(AIController.ocr)

