from flask import Blueprint

from controllers.AIController import AIController
AIRouter = Blueprint('AIRouter', __name__)

AIRouter.route('/', methods=['POST'])(AIController.ocr)
AIRouter.route('/position', methods=['GET'])(AIController.checkPosition)
AIRouter.route('/face', methods=['GET'])(AIController.faceDetect)

