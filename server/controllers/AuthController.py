import uuid
import datetime
from flask import jsonify, request
from flask_bcrypt import Bcrypt
import io
import base64
import cloudinary

cloudinary.config( 
  cloud_name = "nguyenle23", 
  api_key = "647146617223385", 
  api_secret = "6e1Uni92pvYBklSPlgfasV8BaCc",
  secure = True
)

import cloudinary.uploader
import cloudinary.api

from database.DBConnection import DBConnection
from firebase_admin import storage

class AuthController:
  def register():
    email = request.form['email']
    password = request.form['password']
    userAvatar = request.form['userAvatar']
    userLicensePlate = request.form['userLicensePlate']
    userID = str(uuid.uuid4())
    createdAt = datetime.datetime.utcnow()
    updatedAt = datetime.datetime.utcnow()

    if (email == '' or password == '' or userLicensePlate == '' or userAvatar == ''):
      return jsonify({
        'statusCode': '401',
        'message': 'Please fill in all fields',
      })
    
    checkEmailExist = DBConnection('users').where('email', '==', email).get()
    if (len(checkEmailExist) > 0):
      return jsonify({
        'statusCode': '401',
        'message': 'Email already exist'
      })
    if (len(password) < 6):
      return jsonify({
        'statusCode': '401',
        'message': 'Password must be at least 6 characters long'
      })
    checkLicensePlateExist = DBConnection('users').where('userLicensePLate', '==', userLicensePlate.upper()).get()
    if (len(checkLicensePlateExist) > 0):
      return jsonify({
        'statusCode': '401',
        'message': 'License plate already exist'
      })
    else:
      try: 
        password = Bcrypt().generate_password_hash(password).decode('utf-8')

        #decode base64 string to image file
        def decode_image(base64_string):
          image_bytes = io.BytesIO(base64.b64decode(base64_string + '==')) # Add padding to the base64 string
          return image_bytes

        image_file = decode_image(userAvatar)
        print(image_file)

        cloudinary.uploader.upload(image_file, public_id = userID, folder = 'userAvatar')

        url_back = 'https://res.cloudinary.com/nguyenle23/image/upload/v1683619876/userAvatar/' + userID + '.png'

        #upload image to firebase storage
        # bucket = storage.bucket()
        # print(bucket)
        # blob = bucket.blob("images/" + userID)
        # print(blob)
        # blob.upload_from_file(image_file, content_type = 'image/jpg') # Upload the image file object

        # print("---------Image uploaded successfully-----!")
        # url = blob.public_url
        # print('testttttt', url)
  
        #save user to firebase firestore
        data = {
          'userID': userID,
          'email': email,
          'password': password,
          'userAvatar': url_back,
          'userLicensePlate': userLicensePlate.upper(),
          'createdAt': createdAt,
          'updatedAt': updatedAt
        }
        DBConnection('users').document(userID).set(data)
        return jsonify({
          'statusCode': '200',
          'data': data,
        })
      except Exception as e:
        print(e)
        return jsonify({
          'statusCode': '500',
          'message': 'Something went wrong'
        })

  def login():
    try:
      email = request.form['email']
      password = request.form['password']

      #check if email and password is empty
      if (email == '' or password == ''):
        return jsonify({
          'statusCode': '401',
          'message': 'Email and Password is required'
        })
      
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
    except Exception as e:
      print(e)
      return jsonify({
        'statusCode': '500',
        'message': 'Something went wrong'
      })