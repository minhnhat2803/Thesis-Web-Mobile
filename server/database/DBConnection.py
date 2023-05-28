import firebase_admin
from firebase_admin import credentials, firestore
from firebase_admin import credentials

cred = credentials.Certificate({
  "type": "service_account",
  "project_id": "fb-nodejs-25fb0",
  "private_key_id": "3085daf655e2986d4bada547bc5627d661a830ab",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCNiDn5oUOpfW4H\nRclRbw9vfELNuj17jqU2PSJGOKwgZbD1ewnUPBrBmW35MvUt2+nV1t2LHynWQZ17\nZixHxAdGV2KIRw8hkRE/qIjqoeCOtI6A0T+pod+gjSb1Xc0KyxsKCZX8G0O+D+vc\nrBGJMpd+ws23W5Mt2s01NQ/AcVSZ0MpRpiPvdYKh6ENMy37tisbia0x/9Y/IRPCo\n7lf8lr/zclRi0JkyBKH9GreJ4oxT/qywiJc0T8i+8/cElG+/vIOwOyI3u7oifESj\nfCRSxl4oR5K2OkrEyt1r40tSoZyV7VLm/OrF3GnKr8h1BRDavGdfhpR+gmX90GlV\nf2DznjftAgMBAAECgf8M0Fmt9jtuSnsdgsfk1iOa/8GJwlLfxibfcp4fQEw+dSQH\n1xY6PVj7mk70OzzERSqF59dw/6tBfCbLnuv8/3iMsptEiCTFftRPiL+HVue5khbM\nSPJvO8ErP4WXF9ugYs6HXmIwPeFKo5J4m2sz6fpKf78D2s8uhSOouPHtCLC8nPFz\n6M/E7DjPzka+E836YmVSHQdUGifn+ABrfARuaqAsBvnVs2bY5HbOsuHA/YhiAK1k\nlLwdHtiL17qcPnpImh3x3R3xBicDn+pGNmf5kGGMvQbtSPpvyblyW2yIIcGjZe6t\ndEqD8+44xol4cLBW6lvq7qph6jQW5YzuddMfEEECgYEAwhX+/XbRXkAj6yNYYR9u\nUzdCxWL5KbbckDWtGRmEYFTv5wizTKPO7ESd+EhUkZqhkdK0cdXkpYVy07ksvZRT\nsoVFKzUxjNbD1+DPkuoTl4sTbKdOv4ePIgDgDuqboI7SUZsYEkWWALYHa6LfGFi0\n1WtN5aON/8gDSV6FSv5jcpECgYEAuq5uekgIIuWC0bz7rYPc7L1XuLigZ/CdLz3H\nVuOuF9SozSCRulpcu7xVeLkGhLchx3bVb23C9k6dwr1YPiLroiOQpnIiDXT2kTiM\n/8Dl0xpKAQLhyrE2BqHUEPZhDYnwYG3p2wty0azjuZUJ8tdltuU43i+auKHrHm0p\nsgTyJZ0CgYEAoVN9R5wa/ffco1gW32wr3Tni44WYTIc2IRyszF88fII9g1HlD8Bd\ngGCs2jLtMLZStI5q9PBxBPC++KREPzTquUozq22kyUe/NFMm1xyAuoec1sTfHS8F\n16LYmy2BvNzaj4CWaqGyxNaJpnuUa31Ymsl9z3K61rCfor3Rl/uKGDECgYBeOl2Z\na3Jv6tk1dOa0lrKU7J2yp76PuGwexFgyC4p8jOMHZ0EnhyT3vgCGhx47LxTl0Z26\nOPUHznbjLR+1fXrixIDnAwUdNcSfWKQTFBLtk393MzU1Um2qu1SHm1UxuEaU5eX8\norK6E0J/EjOLWB4HS3yA6hZ2y4QaP4+kQ8rWIQKBgQC4++Hvn6lozYwFtdlp3i9k\nVgblGixHMPywb/BlzuWsu7X5fRoQ/cN5b/rw9NEZK2mjA9UD6b69DQ3SDdCvle5x\nwP9eHven2sYB77WuAQMhS0lGQJjsblZN3wUC7dLbIXGZPkNzHyQ5U7Yk4HP+AvQT\n4PkJdr8Xs1MSOxlgTLyEOQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-swa81@fb-nodejs-25fb0.iam.gserviceaccount.com",
  "client_id": "109426410045966214068",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-swa81%40fb-nodejs-25fb0.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
})

firebase_admin.initialize_app(cred, {'storageBucket': 'iot-project-course.appspot.com'})

def DBConnection(collectionName):
  client = firestore.client()
  db = client.collection(collectionName)
  return db
