import firebase_admin
from firebase_admin import credentials, firestore
from firebase_admin import credentials

cred = credentials.Certificate({
"type": "service_account",
  "project_id": "iot-smart-parking-72f94",
  "private_key_id": "c9718890af6195459bdd69d520e13fb56a510253",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCru2vLizKuf7uj\niTJhRQN4adPEg42ZTKQXZFn9Nt+gIK/soSSvapEIxNV+v4eXvZ6Un2UHtGLYHxKb\nADHqiztlvI99DuBrBugcsGOGinx0t1YS8hUBgbSMQaD6KqiNmx/SwH9rG1dj4vln\nqxCxgPSL9ddKMrX83EkdyfVXe+gNxECBtKbgItbomBI0Kw1CXOyLCYggT9UBZC/O\nciXPXnMmC6oSncw3Ki/E/dH/xCFcJcPItlroE7Y9Sd9vpCdTFz852AvfmkEBuLwc\nuDEtqgc3jgd4zORHaYr8hax9B4BKo3l3QcDtRVQhXDnhut0tR1CwNmK6puWQfiuF\nkkwwvw0lAgMBAAECggEACpUZjujsfhlL8EdnjdvpW1W2IYFzy9MPt4tNClAD1sO8\n44mIj7Cy8EXk3BMkYWLjb0glOyTQBH5hsKCB8vCSf/HvK6criBzcV8w8zdEh2zVi\n/fbh+X5LKGtw5omTamp5Owz2rRx5taOKd+twM2f9adSD6EQYt9TBQq8rybDOe26X\nLZwNO6W4SU/eGydnYnDArZXMbnqdljlQuQNBjAfrGIYiiir5cSRP7fh2wKz4TIV+\nLn9cvntK2xFKufanVfj2yI40kLnnz9xrTW1SwfsOWQ8RaBN5KfwL8blzD2vJk5i0\npg7aafkFItetbBP5Woy5V5ZO3BfP9NwLNySCeGlsoQKBgQDRI/iKn7VfvIIqGz39\nMtK1Ti+sd9jpaF9vEsbU0rKFAUfguFRbFllpu6fo0pkUJuJb43A+5MvbAPwGWV/r\nnKwyuwM0CcdcwL1qFMMKoWeG9wLRB5+TMLB96n222HsnimRAY+1jepVvne7Q839E\nvKuAmfvWn1z/D1Z9B0bbbXSOlQKBgQDSNcC/b7APjzey2Tf0l0/z9apo34QBko8a\nyg9fnKNdVUZt1IiKIMymEe6CACWyXvSRUk05uIqt++wdJsmF7yISIso/1Kcmcpnx\nd2OYgOy+z4ZlsKtqampzvq4eOHJLKUQewIK0bhBVWyeqDCjOALh4z5pVL3/HVmYF\nU12QFRowUQKBgQCDVHVEh5nbroKGcmjw0LNkSt7BDNlXaMVU+JOHHXAg+XbrdJT0\nRgqLzN1Z5LVf5DMMxLu9ousocWvRiNolGFNB4BHY4bMhWZ8YOEVqLYTXSdGo9YKN\naWvLBi8/XJ2pbMwbaySs7VNdre1DpURsI5YGwatVUOmS+Uy0YpdqP0eMKQKBgB6B\nrIpbxBpN95BeE8/MUc8e3O9BWN/9jAUgQ+DlU5QM9x6jVHlvTyPewFVffhkHzMh2\nQDzbOk0LnXWRlnd4f+JP6DghPWzH/u1bHToZo8IBTgjd/dKAxRgtGQnLuVKNF5S6\n7X0P6BDrHLOB9j4HPr5Rqp0oOowMTtwBADgTx+wxAoGARBFKiOnSGeviNgTWBgbJ\n4uoAm7wKQ4tqWV8FtbN1sRw9Pb5Z2psVNAPZTw7JuER+iBot65YtUfOAkXF0MzRV\nKtGZxFYNbFqmLEup4+d+6bF9eZtxxdpWeXrl7IOJr1wGLagnfjQZSfnWWizPkm4I\nWfehn+AuGJJUigineU0RuKU=\n-----END PRIVATE KEY-----\n",
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
