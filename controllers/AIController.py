import easyocr  

class AIController:
  def ocr():
    reader = easyocr.Reader(['en'])

    # Load the image
    image_path = 'https://upload.wikimedia.org/wikipedia/commons/5/58/Vietnam_license_plate_07.jpg'

    results = reader.readtext(image_path)

    text = ''
    for result in results:
        text += result[1]

    print("License Plate:", text.replace(" ",""))

    return jsonify(text.replace(" ",""))