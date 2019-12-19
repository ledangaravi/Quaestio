import RPi.GPIO as GPIO # Import Raspberry Pi GPIO library

import time
import math
import Adafruit_ADS1x15
import queue

from firebase_access import checkFirebaseValue, setFirebaseValue
import firebase_access

from config import *

import slider

adc = Adafruit_ADS1x15.ADS1015()


GPIO.setwarnings(False) # Ignore warning for now
GPIO.setmode(GPIO.BCM) # Use physical pin numbering
GPIO.setup(BUTTONIN_NO, GPIO.IN, pull_up_down=GPIO.PUD_DOWN) # IN1
GPIO.setup(BUTTONIN_SKIP, GPIO.IN, pull_up_down=GPIO.PUD_DOWN) # IN2
GPIO.setup(BUTTONIN_YES, GPIO.IN, pull_up_down=GPIO.PUD_DOWN) # IN3
GPIO.setup(BUTTONLED_NO, GPIO.OUT) # IN1
GPIO.setup(BUTTONLED_SKIP, GPIO.OUT) # IN2
GPIO.setup(BUTTONLED_YES, GPIO.OUT) # IN2
GPIO.setup(CHIP_EN, GPIO.OUT) # Chip Enable
GPIO.setup(MOTOR_RIGHT, GPIO.OUT) # IN1
GPIO.setup(MOTOR_LEFT, GPIO.OUT) # IN2

GAIN = 1

class Configuration:
  def __init__(self, yes, no, skip, slider):
    self.yes = yes
    self.no = no
    self.skip = skip
    self.slider = slider

print("Start pi program")
print(checkFirebaseValue("Input"))
try:
    while 1:
        try:
            makeKnobs.end()
        except:
            print("NO object makeKnobs")
        try:
            asyncSetFirebaseValue.end()
        except:
            print("NO object asyncCheckFirebaseValue")
        state = checkFirebaseValue("Current_State")
        slider.disableChip()
        print("state: ", state)
        if state == "Welcome" or state == "Declined" or state == "Introduction":
            configuration = Configuration(True, False, False, False)
        elif state == "Privacy":
            configuration = Configuration(True, True, False, False)
        elif state == "Pull":
            from subprocess import Popen
            Popen('/home/pi/Desktop/human-centered-robotics/pi/quaestio_git_pull.sh', shell=True, stdin=None, stdout=None, stderr=None)
            exit()
        elif state == "Question":
            configuration = Configuration(True, False, False, False)
        else:
            if checkFirebaseValue("Input") == "Buttons":
                configuration = Configuration(True, True, True, False)
            else:
                configuration = Configuration(True, False, True, True)
                slider.initialise()
                asyncSetFirebaseSlider = firebase_access.asyncSetFirebaseSliderValue()
                makeKnobs = slider.makeKnobs()
        GPIO.output(BUTTONLED_YES,configuration.yes)
        GPIO.output(BUTTONLED_NO,configuration.no)
        GPIO.output(BUTTONLED_SKIP,not configuration.skip)
        q = queue.Queue()
        asyncCheckFirebaseValue = firebase_access.asyncCheckFirebaseValue("Current_State",state,q)
        run = True
        while run:
            if q.qsize()>0:
                run = q.get()
            if GPIO.input(BUTTONIN_YES) == GPIO.HIGH and configuration.yes:
                print("Yess pressed")
                if configuration.slider:
                    setFirebaseValue(state, "Yes")
                    makeKnobs.end()
                    asyncSetFirebaseSlider.end()
                    slider.reset()
                else:
                    setFirebaseValue(state,"Yes")
                    time.sleep(0.2)
            elif GPIO.input(BUTTONIN_NO) == GPIO.HIGH and configuration.no:
                setFirebaseValue(state,"No")
                time.sleep(0.2)
            elif GPIO.input(BUTTONIN_SKIP) == GPIO.HIGH and configuration.skip:
                setSkip=False
                #while GPIO.input(BUTTONIN_SKIP) == GPIO.HIGH:
                #    print("wait")
                time.sleep(0.8) 
                for j in range(0,80):
                    time.sleep(0.01)
                    if GPIO.input(BUTTONIN_SKIP) == GPIO.HIGH:
                        print("Pressed END!!!")
                        setSkip=True
                        setFirebaseValue(state, "Exit")
                time.sleep(0.3)
                if not setSkip:
                    print("SetSkip: ", setSkip)
                    setFirebaseValue(state, "Skip")
                if configuration.slider:
                        print("Skip Button Pressed")
                        makeKnobs.end()
                        asyncSetFirebaseSlider.end()
                        slider.reset()
        asyncCheckFirebaseValue.end()

except KeyboardInterrupt:
    print("END")
    GPIO.cleanup()