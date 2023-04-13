import base64
import re
import cv2
import easyocr  
import numpy as np
from flask import jsonify, request

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
  "TP. Đà Nẵng": "43",
  "Đắk Lắk": "47",
  "Đắk Nông": "48",
  "Lâm Đồng": "49",
  "Tp. Hồ Chí Minh": "41, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59",
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
      print('false')
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

    data = {
      "province": found_province,
      "licensePlate": text,
      "plateNumber": str(plateNumber),
    }
    return jsonify(data)