import pyrebase

firebaseConfig = {
    "apiKey": "",
    "authDomain": "",
    "databaseURL": "",
    "projectId": "",
    "storageBucket": "",
    "messagingSenderId": "",
    "appId": "",
    "measurementId": ""
  }

firebase = pyrebase.initialize_app(firebaseConfig)
db = firebase.database()

def getFirebaseValue(childName):
    user = db.child("Hardware_Interface").child(childName).get()
    return user.val()

def setFirebaseValue(state, value):
    db.child("Hardware_Interface").update({state:value})