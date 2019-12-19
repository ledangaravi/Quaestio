import RPi.GPIO as GPIO # Import Raspberry Pi GPIO library

import time
import math
import Adafruit_ADS1x15

from config import *


adc = Adafruit_ADS1x15.ADS1015()


GPIO.setwarnings(False) # Ignore warning for now
GPIO.setmode(GPIO.BCM) # Use physical pin numbering
GPIO.setup(BUTTONIN_NO, GPIO.IN, pull_up_down=GPIO.PUD_DOWN) # IN1
GPIO.setup(BUTTONIN_SKIP, GPIO.IN, pull_up_down=GPIO.PUD_DOWN) # IN2
GPIO.setup(BUTTONIN_YES, GPIO.IN, pull_up_down=GPIO.PUD_DOWN) # IN3
GPIO.setup(BUTTONLED_NO, GPIO.OUT) # IN1
GPIO.setup(BUTTONLED_SKIP, GPIO.OUT) # IN2
GPIO.setup(BUTTONLED_YES, GPIO.OUT) # IN2

GAIN = 1

print("Start pi program")
try:
    while 1:
        if GPIO.input(BUTTONIN_NO) == GPIO.HIGH:
            print(BUTTONIN_NO)
            GPIO.output(BUTTONLED_NO,1)
            time.sleep(0.1)
        if GPIO.input(BUTTONIN_SKIP) == GPIO.HIGH:
            print(BUTTONIN_SKIP)
            GPIO.output(BUTTONLED_SKIP,0)
            time.sleep(0.1)
        if GPIO.input(BUTTONIN_YES) == GPIO.HIGH:
            print(BUTTONIN_YES)
            GPIO.output(BUTTONLED_YES,1)
            time.sleep(0.1)
        else:
            GPIO.output(BUTTONLED_NO,0)
            GPIO.output(BUTTONLED_SKIP,1)
            GPIO.output(BUTTONLED_YES,0)

except KeyboardInterrupt:
    print("END")
    GPIO.cleanup()

