import base64
import datetime
import os
import re
import time
import uuid
import cv2
import easyocr  
import numpy as np
from flask import jsonify, request
import pickle
import face_recognition
import serial
from datetime import datetime
import pytz

from database.DBConnection import DBConnection

serialcom = serial.Serial('COM13', 9600)
serialcom.timeout = 1

provinces = {
  "Cao Bằng": "11",
  "Lạng Sơn": "12",
  "Quảng Ninh": "14",
  "Hải Phòng": "15, 16",
  "Thái Bình": "17",
  "Nam Định": "18",
  "Phú Thọ": "19",
  "Thái Nguyên": "20",
  "Yên Bái": "21",
  "Tuyên Quang": "22",
  "Hà Giang": "23",
  "Lào Cai": "24",
  "Điện Biên": "25",
  "Lai Châu": "26",
  "Sơn La": "27",
  "Hòa Bình": "28",
  "Hà Nội": "29, 30, 31, 32, 33, 40",
  "Hải Dương": "34",
  "Ninh Bình": "35",
  "Thanh Hoá": "36",
  "Nghệ An": "37",
  "Hà Tĩnh": "38",
  "Đà Nẵng": "43",
  "Đắk Lắk": "47",
  "Đắk Nông": "48",
  "Lâm Đồng": "49",
  "Hồ Chí Minh": "41, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59",
  "Đồng Nai": "39, 60",
  "Bình Dương": "61",
  "Long An": "62",
  "Tiền Giang": "63",
  "Vĩnh Long": "64",
  "Cần Thơ": "65",
  "Đồng Tháp": "66",
  "An Giang": "67",
  "Kiên Giang": "68",
  "Cà Mau": "69",
  "Tây Ninh": "70",
  "Bến Tre": "71",
  "Bà Rịa - Vũng Tàu": "72",
  "Quảng Bình": "73",
  "Quảng Trị": "74",
  "Thừa Thiên Huế": "75",
  "Quảng Ngãi": "76",
  "Bình Định": "77",
  "Phú Yên": "78",
  "Khánh Hòa": "79",
  "Gia Lai": "81",
  "Kon Tum": "82",
  "Sóc Trăng": "83",
  "Trà Vinh": "84",
  "Ninh Thuận": "85",
  "Bình Thuận": "86",
  "Bình Phước": "87",
  "Hưng Yên": "89",
  "Hà Nam": "90",
  "Quảng Nam": "92",
  "Bình Phước": "93",
  "Bạc Liêu": "94",
  "Hậu Giang": "95",
  "Bắc Kạn": "97",
  "Bắc Giang": "98",
  "Bắc Ninh": "99", 
}

class AIController:
  def checkPosition():
    checkPosition = serialcom.readline().decode('utf-8').rstrip()
    print(checkPosition)
    return checkPosition

  def faceDetect():
    cap = cv2.VideoCapture(0)
    cap.set(3, 640)
    cap.set(4, 480)
    
    def encodeGenerator():
      #Encode generator
      folderPath = './data/face'
      pathList = os.listdir(folderPath)
      imgList = []
      imgID = []
      for path in pathList:
        imgList.append(cv2.imread(os.path.join(folderPath, path)))
        id = os.path.splitext(path)[0]
        imgID.append(id)
      return [imgList, imgID]

    def findEncodings(imgList):
      encodeList = []
      for img in imgList:
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        encode = face_recognition.face_encodings(img)[0]
        encodeList.append(encode)
      return encodeList
    
    encodeListKnown = findEncodings(encodeGenerator()[0])
    encodeListKnownWithID = [encodeListKnown, encodeGenerator()[1]]

    file = open('./data/EncodeFile.p', 'wb')
    pickle.dump(encodeListKnownWithID, file)
    file.close()
    print('file saved')

    #Load encode file
    print('loading encode file')
    file = open('./data/EncodeFile.p', 'rb')
    encodeListKnownWithID = pickle.load(file)
    file.close()
    encodeListKnown, imgID = encodeListKnownWithID
    print('encode file loaded')

    while True:
      success, img = cap.read()

      imgS = cv2.resize(img, (0, 0), None, 0.25, 0.25)
      imgS = cv2.cvtColor(imgS, cv2.COLOR_BGR2RGB)
      
      faceCurFram = face_recognition.face_locations(imgS)
      encodeCurFram = face_recognition.face_encodings(imgS, faceCurFram)

      if faceCurFram:
        for encodeFace, faceLoc in zip(encodeCurFram, faceCurFram):
          matches = face_recognition.compare_faces(encodeListKnown, encodeFace)
          faceDis = face_recognition.face_distance(encodeListKnown, encodeFace)

          matchIndex = np.argmin(faceDis)
          if matches[matchIndex]:
            print('id', imgID[matchIndex])
            #print the image matched
            name = imgID[matchIndex]
            y1, x2, y2, x1 = faceLoc
            y1, x2, y2, x1 = y1 * 4, x2 * 4, y2 * 4, x1 * 4
            cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)
            cv2.rectangle(img, (x1, y2-35), (x2, y2), (0, 255, 0), cv2.FILLED)
            cv2.putText(img, name, (x1+6, y2-6), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 255, 255), 2)
            cv2.imshow('Webcam', img)
            cv2.waitKey(1)
        else:
          print('not found')
          return jsonify({"message": "Not found face to detect"})

  def ocr():
    data = request.json
    image = data['imageSrc']
    
    #convert string to base64
    image = image.split(',')[1]
    image = image.encode('utf-8')
    image = base64.b64decode(image)
    
    #convert base64 to image
    image = np.fromstring(image, np.uint8)
    image = cv2.imdecode(image, cv2.IMREAD_COLOR)
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    reader = easyocr.Reader(['en'], )
    results = reader.readtext(gray_image, detail=0, threshold=0.5)
    text = ''
    for result in results:
        text += result

    localNumber = text[:2]
    found_province = None

    if text == '':
      return jsonify({"message": "No license plate found"})
    
    for province, plate_number in provinces.items():
      if localNumber in plate_number:
        found_province = province
        break

    plateNumber = None
    text = text.replace(" ", "")
    if('.' in text):
      pattern = r"\d{3}\.\d{2}$"
      match = re.search(pattern, text)
      if match:
        plateNumber = match.group(0)
      else:
        plateNumber = 'None'
        print("Plate number not found")
    else:
      pattern = r"\d{4}$"
      match = re.search(pattern, text)
      if match:
        plateNumber = match.group(0)
      else:
        plateNumber = 'None'
        print("Plate number not found")

    print("Province:", found_province)
    print("License Plate:", text)
    print("Plate Number:", plateNumber)

    checkUserExist = DBConnection('users').where('userLicensePlate', '==', text)
    if checkUserExist:
      print("User exist")
      serialcom.write(str('true').encode())
      print("Sending signal to Arduino")
      
      billID = str(uuid.uuid4())
      user_query_result = checkUserExist.get()
      userID = ''
      for i in user_query_result:
        getUserID = i.to_dict()['userID']
        userID = getUserID
      print(userID)

      vietnam_timezone = pytz.timezone('Asia/Ho_Chi_Minh')
      current_time = datetime.now(vietnam_timezone)
      current_time_str = current_time.strftime('%Y-%m-%d %H:%M:%S')

      DBConnection('bills').document(billID).set({
        "userID": userID,
        "fee": "20000",
        "slot": "A1",
        "timeIn": current_time_str,
      })

      data = {
        "message": "User exist",
        "province": found_province,
        "licensePlate": text,
        "plateNumber": str(plateNumber),
        "status": "success",
        "slot": "A1"
      }
      return jsonify(data)
    else:
      print("User not exist")
      data = {
        "message": "User not exist",
        "status": "fail"
      }
      return jsonify(data)