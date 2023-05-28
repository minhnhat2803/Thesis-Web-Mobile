from flask import Blueprint

from controllers.BillController import BillController
BillRouter = Blueprint('BillRouter', __name__)

BillRouter.route('/<userID>', methods=['GET'])(BillController.getBillByUserID)

