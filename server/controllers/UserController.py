
import uuid
import datetime
from flask import jsonify, request
from flask_bcrypt import Bcrypt

from controllers.ErrorController import not_found
from database.DBConnection import DBConnection

class UserController:
  def createAndGetUser():
    if request.method == 'POST':
      data = request.json
      data['userID'] = str(uuid.uuid4())
      data['createdAt'] = datetime.datetime.utcnow()
      data['updatedAt'] = datetime.datetime.utcnow()

      if (len(data['password']) < 6):
        return jsonify('Password must be at least 6 characters long')
      else:
        data['password'] = Bcrypt().generate_password_hash(data['password']).decode('utf-8')
        checkEmailExist = DBConnection('users').where('phoneNumber', '==', data['phoneNumber']).get()
        if (len(checkEmailExist) > 0):
          return jsonify('Phonenumber already exist')
        else:
          DBConnection('users').document(data['userID']).set(data)
          return jsonify('User created successfully')
    elif request.method == 'GET':
      data = []
      getUsers = DBConnection('users').get()
      for user in getUsers:
        data.append(user.to_dict())

      for i in range(len(data)):
        retrievedData = DBConnection('bills').where('userID', '==', data[i]['userID']).get()
        if (len(retrievedData) > 0):
          data[i]['bill'] = retrievedData[0].to_dict()
        else:
          data[i]['bill'] = None

      return jsonify(data)
    
  def getUserByID(userID):
      getUser = DBConnection('users').document(userID).get()
      if (getUser.exists):
        return jsonify(getUser.to_dict())
      else:
        return not_found(userID)

  def updateUserByID(userID):
    data = request.json
    data['updatedAt'] = datetime.datetime.utcnow()

    checkUser = DBConnection('users').document(userID).get()
    if (checkUser.exists):
      # data['password'] = Bcrypt().generate_password_hash(data['password']).decode('utf-8')
      DBConnection('users').document(userID).update(data)
      return jsonify('User updated successfully')
    else:
      return not_found(userID)

  def deleteUserByID(userID):
    checkUser = DBConnection('users').document(userID).get()
    if (checkUser.exists):
      DBConnection('users').document(userID).delete()
      return jsonify('User deleted successfully')
    else:
      return not_found(userID)