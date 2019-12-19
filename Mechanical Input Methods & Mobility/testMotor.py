import RPi.GPIO as GPIO # Import Raspberry Pi GPIO library

import time
import math
import Adafruit_ADS1x15

from config import *

import slider


adc = Adafruit_ADS1x15.ADS1015()


GPIO.setwarnings(False) # Ignore warning for now
GPIO.setmode(GPIO.BCM) # Use physical pin numbering
GPIO.setup(CHIP_EN, GPIO.OUT) # Chip Enable
GPIO.setup(MOTOR_RIGHT, GPIO.OUT) # IN1
GPIO.setup(MOTOR_LEFT, GPIO.OUT) # IN2

GAIN = 1

GPIO.output(CHIP_EN, 0)
GPIO.output(MOTOR_RIGHT, 0)
GPIO.output(MOTOR_LEFT, 0)
#motor_right = GPIO.PWM(MOTOR_RIGHT, 100)
#motor_right.start(0)
#motor_left = GPIO.PWM(MOTOR_LEFT, 100)
#motor_left.start(0)
#GPIO.output(, 0)
print("Start pi program")
try:
    while 1:
        motorInput = input("Motor left (l) or right (r), or makeKnobs (k) or else test values: ")
        if motorInput == "l":
            try:
                makeKnobs.end()
            except:
                print("NO object makeKnobs")
            print("left")
            while 1:
                GPIO.output(CHIP_EN, 1)
                GPIO.output(MOTOR_RIGHT, 0)
                GPIO.output(MOTOR_LEFT, 1)
        elif motorInput == "r":
            try:
                makeKnobs.end()
            except:
                print("NO object makeKnobs")
            while 1:
                GPIO.output(CHIP_EN, 1)
                GPIO.output(MOTOR_RIGHT, 1)
                GPIO.output(MOTOR_LEFT, 0)
        elif motorInput == "k":
            makeKnobs = slider.makeKnobs()
        else:
            while 1:
                time.sleep(1)
                values = adc.read_adc(0, gain=GAIN)
                print(values)
                values = values/SLIDER_FACTOR
                print(values)
except KeyboardInterrupt:
    print("END")
    GPIO.cleanup()