import uuid
import datetime
from flask import jsonify, request
from flask_bcrypt import Bcrypt
import io
import base64
import cloudinary
import re
import firebase_admin
from firebase_admin import firestore, auth

# Khởi tạo Firebase app
firebase_admin.initialize_app()

# Khởi tạo Cloudinary
cloudinary.config( 
  cloud_name= 'dwxwzfinh', 
  api_key= '718972236811852', 
  api_secret= 'Q1KjxE2lXiEBOibOLHwLmlUvcrU', 
  secure=True
)

import cloudinary.uploader
import cloudinary.api

from database.DBConnection import DBConnection  # Mobile database connection

class AuthController:
  def register():
    platform = request.headers.get('Platform')  # Nhận thông tin nền tảng từ header

    if platform == 'mobile':
      # Logic đăng ký cho mobile
      email = request.form['email']
      password = request.form['password']
      userAvatar = request.form['userAvatar']
      userLicensePlate = request.form['userLicensePlate']
      userID = str(uuid.uuid4())
      createdAt = datetime.datetime.utcnow()
      updatedAt = datetime.datetime.utcnow()

      if email == '' or password == '' or userLicensePlate == '' or userAvatar == '':
        return jsonify({
          'statusCode': '401',
          'message': 'Please fill in all fields',
        })
      
      checkEmailExist = DBConnection('users').where('email', '==', email).get()
      if len(checkEmailExist) > 0:
        return jsonify({
          'statusCode': '401',
          'message': 'Email already exists'
        })
      if len(password) < 6:
        return jsonify({
          'statusCode': '401',
          'message': 'Password must be at least 6 characters long'
        })

      try: 
        password = Bcrypt().generate_password_hash(password).decode('utf-8')

        # Decode base64 string to image file and determine file extension
        def decode_image(base64_string):
          if "data:image" in base64_string:
            format_match = re.match(r"data:image/(\w+);base64,", base64_string)
            if format_match:
              file_extension = format_match.group(1)
              base64_string = re.sub(r"data:image/\w+;base64,", "", base64_string)
            else:
              file_extension = 'jpg'  # Default to jpg if not found
          else:
            file_extension = 'jpg'

          image_bytes = io.BytesIO(base64.b64decode(base64_string + '=='))
          return image_bytes, file_extension

        image_file, file_extension = decode_image(userAvatar)

        # Upload to Cloudinary
        cloudinary.uploader.upload(image_file, public_id=userID, folder='userAvatar', resource_type="image", format=file_extension)

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

    elif platform == 'web':
      # Logic đăng ký cho web
      fullName = request.form['fullName']
      email = request.form['email']
      password = request.form['password']
      confirmPassword = request.form['confirmPassword']

      if password != confirmPassword:
        return jsonify({
          'statusCode': '401',
          'message': 'Passwords do not match'
        })

      try:
        userCredential = auth.create_user(email=email, password=password)
        userID = userCredential.uid

        data = {
          'fullName': fullName,
          'email': email,
          'phoneNumber': request.form['phoneNumber'],
          'profilePicture': request.form.get('profilePicture'),
          'workingHours': "Ca sáng (7:00 - 15:00)",
          'lastLogin': datetime.datetime.utcnow(),
          'activityHistory': [],
          'parkingInfo': request.form['parkingInfo'],
          'status': 'Đang hoạt động'
        }
        firestore.client().collection('users').document(userID).set(data)

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
    platform = request.headers.get('Platform')

    if platform == 'mobile':
      # Logic đăng nhập cho mobile
      email = request.form['email']
      password = request.form['password']

      if email == '' or password == '':
        return jsonify({
          'statusCode': '401',
          'message': 'Email and Password are required'
        })
      
      checkUser = DBConnection('users').where('email', '==', email).get()
      if len(checkUser) > 0:
        for user in checkUser:
          if Bcrypt().check_password_hash(user.to_dict()['password'], password):
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
          'message': 'Your email does not exist'
        })

    elif platform == 'web':
      # Logic đăng nhập cho web
      email = request.form['email']
      password = request.form['password']

      try:
        userCredential = auth.sign_in_with_email_and_password(email, password)
        userID = userCredential['localId']

        userDoc = firestore.client().collection('users').document(userID).get()
        if userDoc.exists:
          return jsonify({
            'statusCode': '200',
            'data': userDoc.to_dict(),
          })
        else:
          return jsonify({
            'statusCode': '404',
            'message': 'User not found'
          })
      except Exception as e:
        print(e)
        return jsonify({
          'statusCode': '500',
          'message': 'Something went wrong'
        })
