
import uuid
import datetime
from flask import jsonify, request
from flask_bcrypt import Bcrypt

from controllers.ErrorController import not_found
from database.DBConnection import DBConnection

class BillController:
  def getBillByUserID(userID):
    getUser = DBConnection('bills').where('userID', '==', userID)
    userBill = getUser.get()
    data = []
    for i in userBill:
      data.append(i.to_dict())
    return jsonify(data)