import firebase_admin
from firebase_admin import credentials, firestore
from firebase_admin import credentials

# cred = credentials.Certificate({
#   "type": "service_account",
#   "project_id": "iot-project-course",
#   "private_key_id": "f525a5e6ec4b8b4ce408093105481642843c343e",
#   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC1j6MdgvLh/GVR\nJEvG2xQbhyvctn0/ZkykD5TokkDYGFt+zCYpK9fOd+/Z3XG1Rn1hKis3VNguqe48\nQC/4piVxue6JUbloAYtCgz+8dI6KRKzX3atPf8tvK2qEJpNJ6arqOPUpUCEPGBCT\nLq2ja9GH5AgzPLNPrOBC1xjRG1yTe8iXJgT1gMpot4JLV2sKd7Vt7r6Nk6VFe5rh\npMwNJJdU+BequGW3IDhkMOUBnhOXlP5Lg1/gq/lS4SS4xoHm3eO6SEytWtRUtL6b\nmkdKbVIAgjD6WYS/53SGtOtJUMzGzJDlsoDgEtHxo6nOJCWZDwLAOtVWYO0epHpC\nufDtMScVAgMBAAECggEAD0vF6O2unoK/9GlggVg7cvBDetZDA6B2ORiSkB9vzn5x\nPH1gtg8NoN7lrZvXtKp27Xf66RZas8Yfau/YOsegl8EbpNgzDKo1b2Nh7ybj5VrQ\nzWTm+Sa7XsCWujU+KzfZuhIVxKb0Cgxm3q3ljty9nwgc94tLHgP8ZshhVlvKqlmn\nhE+kSyHEXnn/mYwVw7rrYn3diEXu4N3+U16eJSSMaYY6xSDtBzb2uGxk2WSLSeRF\nQl8+Eo8k/PeqhpCT9ZkLciP2y5gH+reHZrxnuGf+HI34GaC6P69VPW1Ho0V6pEVI\ne1mP1TsC5mQV1mjq7PD5rseCsnmTivql8F0kgZUyxwKBgQDwirDul3toJHt5HCxs\n4duWShdlsMGvPbw1R9EGbYZhrN8Wu+uoEruCtHwiw3z21W+a1HSndG7n1DRkBnz0\nGe+PF6QYrKGBn4qwwyMyR7nav6D1VLLFDX2WNTYjTVQefP2vUItuJTjR7Hz1sdLF\nyZqPG1de2YJNG1B2a6WWBbcn6wKBgQDBOp3VYJ6NtGi14/QycdrTgLgSfJSALDv5\nHG29DpJm/I97kDHq9VNPxSPvqKCiINKMgsT6X6Kw31TOZDiM6CI3dmv7mvV1/Dlo\n3QqKorpJEiFGki5Y0diIjEW5lwim4aHQ1D/8gc9ooEhqNU+oNm3Jr/hkvCV5148n\nY2lQDaws/wKBgANXCanmdJI3n3dJCtzgLfpiQPzqfWX/h3N98csTDkCg8+AO7/C/\ngdcIxoh9CmkrAYe213/TwA58BdY1uNpy2b6051RoYT25h2V48C4sjMoayxNc/7Z4\nv3usdXn8AuUBe0xJ5AW9gpJ3pCyNMY4JhJnkGUx53LNRY8ahLAVvQuHNAoGAJR7L\nn2g2TWaxDvBBw0cYELWTpwmDxbO5ubt6YW1hNqOiNMyYqliCrrpikvHEGiFQEWo1\nyRuCN5RPyG58ZqVZnWoEiItWSFox9TExizyDqPHwrov6l1mIzYKVCng3U0fZPDLq\nL+oIHENeZfjj2p7KLIq/nyp90JBWkeyJGLXns6UCgYALhEpRhkhtu3HaiFC1k9AR\nytY1KmGmNS5Pm8LY7Kq6RSVLGwZVud12JIaPPgwCIdvGFl9Yj2x2fZsfvDbBawVj\nPbO76v8xSmZrcY27vO5jzl5b8Ga1CURbFkHfMY/f8hmehAd1ULjDzBfkGfMiFzQl\n1L3BuHJEnBnBgN48ZqgZyQ==\n-----END PRIVATE KEY-----\n",
#   "client_email": "firebase-adminsdk-667uk@iot-project-course.iam.gserviceaccount.com",
#   "client_id": "103029806485891817020",
#   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
#   "token_uri": "https://oauth2.googleapis.com/token",
#   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
#   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-667uk%40iot-project-course.iam.gserviceaccount.com"
# })
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
