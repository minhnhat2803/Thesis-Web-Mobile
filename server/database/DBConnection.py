import firebase_admin
from firebase_admin import credentials, firestore
from firebase_admin import credentials

cred = credentials.Certificate({
"type": "service_account",
  "project_id": "iot-smart-parking-72f94",
  "private_key_id": "435656757049f82801be1e932e74e53e89be5f0d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDzpHNd+fraMQz1\njfPqx5ox0UGbTi8IXNU2jCFQwI926llHGiCnggihwuOK12sf1WfyaxS+ip+GOWzo\n4ZC9+CaxkqvJcbvr6EV4cykkj879D078IyrndHrvohbNKJgjBKPzAFKdvRwRrm0O\nTZAj/6YKYr2a5lbnDehjXtBgINQJR1uF529paqUiKCbyUZ+zpcuNo9SyZ/AiiHi0\nGxHPlH80BRe7+uBPMeH0ibHPlK/7qSbY3j+fwS4yO5aH0AJXeGua8cdetS4kgmnH\nDmawd1e0QUy8L36O88An6ucheeUC+TTK76POfD85GhJ8F7w7Xe4NPBzHIHIOBdpT\np590YNe1AgMBAAECggEABcJxNLtEVhSbQxHGPppV15AkDiUQwRCavLWe0v8eVRgQ\noLjqJTOSeyp1gRJ7Fo9PrAAihyeVQlHItI+igY8kcQWv2Gz/HYJJ5CFKy3G32a0b\nN6QoLz0Ga/RHuDVZtVg2fPfYvCBckcFvFAu62NMCDJRNeaQw0Tj3saOr5t3XzVlN\n7mQjTl9lIUo6FL0lnU9cjeJHC4KaDIxLtBBcyCjUBpQQUAlg8I/lBCtT/kJ8n3kg\nGKUTCna+HamIGtSX5JOkbdDTy/bauK7JbnJW3bdQprf5U+GvEMTTZHp3pPhSWk3v\nBr/ltN1Go1nTJhjhtWEBIXfRQ0w/xfAbmM3hx006CQKBgQD8KSk8Wc3s6H0q2WBq\n18h/HRn2vsXHe3PoWT6N9OJ5vmtNg99rxtGVbnA/Q7TE9arjaM2oYD4KoJL0ioXl\nEopw/FOqu6YpYdqIJpiSPDpTC2nQH8lWa3yFK73SaADoOydTyhgLSiT6ttuMwRcA\nAHlRJqCo1rCjXzLbcPDW4jHY/QKBgQD3WhZybePwK5A8q83T6SEHVAVa81HspTSp\naYQDNdlcBRkVwldb6+uLBAn4dbxT9U3bX61/fQSNDMfHJnFyN2pSc8cdSoF1cuJb\nnm7BZp4JZ5eSclffRmQTuzfXuDKVJ0gtpRrGCfuO7dKJiz48tA/yIOeXSCL1XBls\niacH0/1zGQKBgQCcW/Gj6JPWeXtT3KL63X8Hw0XcSQNe5OBEjUJKyDS/BSKIWGNr\n80b2gBq+P/+RujwS82PDKpqOAG/fjx3jo5GQ6gX/cohgVLsrfbNRymLoJ8WfNnak\nTdZSxYLZO4CEgFmsjT5HkdxIUqblKr5WU/TmKyuoRigVxexFQk01EeGTCQKBgQDV\ncbbXDb7ZHC5+PF8EEzN+KGHqpvc19yWnXzccshYb0wZfgXFzD/UU4+parfZSmOaT\nfE+yKMaJlNK8Jo9U2T71YZUb0JRALl/oYaH/YDbVtL/WDreHIy3u3OqGSxvTG6+s\nO8ILzMd4Af9g03hkV5k+/mf6YrRP+Ca0Q2CQX71g2QKBgDK2F3ErFC/aB1ABo1ic\nxs93biWgOu3W3/0pDimLM+0BJmyo9MAOZGKksci/7RCwk1woYhy+tGynR2hRhrRE\nuWdMz2UINrUR2QAP47MJl/Fq96rigoGfQZ0z8Plj3DqfR8lboyeSXa/3mUwxMgXl\n4tPiULI+DFJfBL3Ws/1UaC+y\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-6ubd4@iot-smart-parking-72f94.iam.gserviceaccount.com",
  "client_id": "117564580450737501517",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-6ubd4%40iot-smart-parking-72f94.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
})

firebase_admin.initialize_app(cred, {'storageBucket': 'iot-smart-parking-72f94.appspot.com'})

def DBConnection(collectionName):
  client = firestore.client()
  db = client.collection(collectionName)
  return db
