import uuid
import datetime
from flask import jsonify, request
from flask_bcrypt import Bcrypt
import io
import base64
import cloudinary
import re

cloudinary.config( 
  cloud_name= 'dwxwzfinh', 
  api_key= '718972236811852', 
  api_secret= 'Q1KjxE2lXiEBOibOLHwLmlUvcrU', 
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

    else:
      try: 
        password = Bcrypt().generate_password_hash(password).decode('utf-8')

        # Decode base64 string to image file and determine file extension
        def decode_image(base64_string):
          # Check if base64 string contains format info (e.g. data:image/png;base64,...)
          if "data:image" in base64_string:
            format_match = re.match(r"data:image/(\w+);base64,", base64_string)
            if format_match:
              file_extension = format_match.group(1)
              base64_string = re.sub(r"data:image/\w+;base64,", "", base64_string)
            else:
              file_extension = 'jpg'  # Default to jpg if not found
          else:
            file_extension = 'jpg'

          image_bytes = io.BytesIO(base64.b64decode(base64_string + '==')) # Add padding to the base64 string
          return image_bytes, file_extension

        image_file, file_extension = decode_image(userAvatar)
        print(f"Uploading as {file_extension}")

        # Upload to Cloudinary with correct format
        cloudinary.uploader.upload(image_file, public_id = userID, folder = 'userAvatar', resource_type="image", format=file_extension)

        # Construct URL with the correct file extension
        url_back = f'https://res.cloudinary.com/dwxwzfinh/image/upload/v1725953916/userAvatar/{userID}.{file_extension}'

        data = {
          'userID': userID,
          'email': email,
          'password': password,
          'userAvatar': url_back,
          'userLicensePlate': userLicensePlate.upper(),
          'createdAt': createdAt,
          'updatedAt': updatedAt
        }
        print(data)
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
