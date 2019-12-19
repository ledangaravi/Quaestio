import pyrebase
from urllib.request import urlopen
import threading
import queue
import time

import slider

firebaseConfig = {
    "apiKey": "AIzaSyDR4MYczuwRwAq0gmAyNHl_kURK3UmWlYs",
    "authDomain": "questio-a802f.firebaseapp.com",
    "databaseURL": "https://questio-a802f.firebaseio.com",
    "projectId": "questio-a802f",
    "storageBucket": "questio-a802f.appspot.com",
    "messagingSenderId": "57510774469",
    "appId": "1:57510774469:web:ab847710cf70c19026d2ac",
    "measurementId": "G-02H2ZTQ7HW"
  }

firebase = pyrebase.initialize_app(firebaseConfig)

# Get a reference to the database service
db = firebase.database()
db2 = firebase.database()

def checkFirebaseValue(childName):
    try:
        user = db.child("Hardware_Interface").child(childName).get()
        return user.val()
    except:
        return ""

def setFirebaseValue(state, value):
    print("SET: ", state, " VALUE: ", value)
    db.child("Hardware_Interface").update({state:value})

class asyncCheckFirebaseValue():
    def __init__(self, childName, state, q):
        self.is_running = True
        self.childName = childName
        self.state = state
        self.q = q
        thread = threading.Thread(target=self.run, args=())
        thread.daemon = True
        thread.start()
    def end(self):
        self.is_running = False
    def run(self):
        while self.is_running:
            if self.state == checkFirebaseValue(self.childName):
                self.q.put(True)
            else:
                self.q.put(False)
                
    

class asyncSetFirebaseSliderValue():
    def __init__(self):
        self.is_running = True
        thread = threading.Thread(target=self.run, args=())
        thread.daemon = True
        thread.start()
    def end(self):
        self.is_running = False
    def run(self):
        while self.is_running:
            db2.child("Hardware_Interface").update({"Current_Slider_Value":slider.getLevel()})
