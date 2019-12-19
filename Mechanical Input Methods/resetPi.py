import firebase_access
import time

while 1:
    time.sleep(5)
    state = firebase_access.checkFirebaseValue("Current_State")
    if state == "Restart":
        import os
        os.system("sudo reboot now")
    if state == "Reset":
        import os
        os.system("python3 /home/pi/Desktop/human-centered-robotics/main.py")
