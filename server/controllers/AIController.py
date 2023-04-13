import base64
import cv2
import easyocr  
import numpy as np
from flask import jsonify, request

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
    
    # reader = easyocr.Reader(['en'], )
    # results = reader.readtext(gray_image, detail=0, threshold=0.5)
    # text = ''
    # for result in results:
    #   text += result
    # print("License Plate:", text.replace(" ",""))
    # return jsonify(text.replace(" ",""))


    # image_path = './data/test.jpg'
    # input_image = cv2.imread(image_path)
    # gray_image = cv2.cvtColor(input_image, cv2.COLOR_BGR2GRAY)
    reader = easyocr.Reader(['en'], )
    results = reader.readtext(gray_image, detail=0, threshold=0.5)
    text = ''
    for result in results:
        text += result
    print("License Plate:", text.replace(" ",""))
    return jsonify(text.replace(" ",""))
  
    # reader = easyocr.Reader(['en'])
    # image_path = './data/test3.jpg'
    # ocr_result = reader.readtext(image_path)
    # print("License Plate:", ocr_result)

    # confidence_threshold = 0.2

    # for dection in ocr_result:
    #   if dection[2] > confidence_threshold:
    #     top_left = tuple([int(val) for val in dection[0][0]])
    #     bottom_right = tuple([int(val) for val in dection[0][2]])
    #     text = dection[1]
    #     img = cv2.imread(image_path)
    #     img = cv2.rectangle(img, top_left, bottom_right, (255, 0, 0), 2)
    #     img = cv2.putText(img, text, top_left, cv2.FONT_HERSHEY_SIMPLEX, 3, (0, 0, 255), 3, cv2.LINE_AA)

    # # # Get the confidence score
    # # top_left = tuple(ocr_result[0][0][0])
    # # bottom_right = tuple(ocr_result[0][0][2])

    # # # Get the text
    # # text = ocr_result[0][1]
    
    # # img = cv2.imread(image_path)
    # # img = cv2.rectangle(img, top_left, bottom_right, (255, 0, 0), 5)
    # # img = cv2.putText(img, text, top_left, cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 1, cv2.LINE_AA)

    # cv2.imshow('img', img)
    # cv2.waitKey(0)

    # return jsonify('test')
  
    