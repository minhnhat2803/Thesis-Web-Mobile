import uuid
import datetime
from flask import jsonify, request
from flask_bcrypt import Bcrypt

from database.DBConnection import DBConnection

class AuthController:
  def register():
    email = request.form['email']
    password = request.form['password']
    userID = str(uuid.uuid4())
    createdAt = datetime.datetime.utcnow()
    updatedAt = datetime.datetime.utcnow()

    data = {
      'userID': userID,
      'email': email,
      'password': password,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    }

    if (len(password) < 6):
      return jsonify({
        'statusCode': '401',
        'message': 'Password must be at least 6 characters long'
      })
    else:
      password = Bcrypt().generate_password_hash(password).decode('utf-8')
      checkEmailExist = DBConnection('users').where('email', '==', email).get()
      if (len(checkEmailExist) > 0):
        return jsonify({
          'statusCode': '401',
          'message': 'Email already exist'
        })
      else:
        DBConnection('users').document(userID).set(data)
        return jsonify({
          'statusCode': '200',
          'data': data,
        })
    
  def login():
    email = request.form['email']
    password = request.form['password']
    
    checkUser = DBConnection('users').where('email', '==', email).get()
    if (len(checkUser) > 0):
      for user in checkUser:
        if (Bcrypt().check_password_hash(user.to_dict()['password'], password)):
          return jsonify({
            'statusCode': '200',
            'data': user.to_dict(),
            'message': 'Login successfully'
          })
        else:
          return jsonify({
            'statusCode': '401',
            'message': 'Wrong password'
          })
    else:
      return jsonify({
        'statusCode': '404',
        'message': 'Your email is not existed'
      })