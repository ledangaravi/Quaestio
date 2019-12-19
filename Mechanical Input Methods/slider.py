import RPi.GPIO as GPIO # Import Raspberry Pi GPIO library

import time
import math
import Adafruit_ADS1x15
import threading

from timeouterror import timeout

from config import *


adc = Adafruit_ADS1x15.ADS1015()


GPIO.setwarnings(False) # Ignore warning for now
GPIO.setmode(GPIO.BCM) # Use physical pin numbering
GPIO.setup(CHIP_EN, GPIO.OUT) # Chip Enable
GPIO.setup(MOTOR_RIGHT, GPIO.OUT) # IN1
GPIO.setup(MOTOR_LEFT, GPIO.OUT) # IN2

motor_right = GPIO.PWM(MOTOR_RIGHT, 100)
motor_right.start(0)
motor_left = GPIO.PWM(MOTOR_LEFT, 100)
motor_left.start(0)

GAIN = 1

def reset():
    GPIO.output(CHIP_EN, 1)
    values = adc.read_adc(0, gain=GAIN)
    values = math.floor(values/SLIDER_FACTOR)
    GPIO.output(MOTOR_RIGHT, 0)
    GPIO.output(MOTOR_LEFT, 1)
    with timeout(1):
        while values>50:
            GPIO.output(CHIP_EN, 1)
            GPIO.output(MOTOR_RIGHT, 0)
            GPIO.output(MOTOR_LEFT, 1)
            values = adc.read_adc(0, gain=GAIN)
            values = math.floor(values/SLIDER_FACTOR)
            #motor_right.ChangeDutyCycle(0)
            #motor_left.ChangeDutyCycle(80)
    GPIO.output(MOTOR_RIGHT, 0)
    GPIO.output(MOTOR_LEFT, 0)
    print("end reset")
    GPIO.output(CHIP_EN, 0)
def initialise():
    print("start initialise")
    GPIO.output(CHIP_EN, 1)
    values = adc.read_adc(0, gain=GAIN)
    values = math.floor(values/SLIDER_FACTOR)
    with timeout(2):
        while values<800:
            values = adc.read_adc(0, gain=GAIN)
            values = math.floor(values/SLIDER_FACTOR)
            GPIO.output(CHIP_EN, 1)
            GPIO.output(MOTOR_RIGHT, 1)
            GPIO.output(MOTOR_LEFT, 0)
        while values>50:
            values = adc.read_adc(0, gain=GAIN)
            values = math.floor(values/SLIDER_FACTOR)
            GPIO.output(CHIP_EN, 1)
            GPIO.output(MOTOR_RIGHT, 0)
            GPIO.output(MOTOR_LEFT, 1)
    GPIO.output(MOTOR_RIGHT, 0)
    GPIO.output(MOTOR_LEFT, 0)
    GPIO.output(CHIP_EN, 0)
    print("end initialise")
def getValue():
    values = adc.read_adc(0, gain=GAIN)
    values = math.floor(values/SLIDER_FACTOR)
    return values
def getLevel():
    value = getValue()
    if value < 250:
        return "1"
    elif value < 450:
        return "2"
    elif value < 650:
        return "3"
    elif value < 850:
        return "4"
    else:
        return "5"

class makeKnobs():
    def __init__(self):
        self.is_running = False
        thread = threading.Thread(target=self.run, args=())
        thread.daemon = True
        thread.start()
    def end(self):
        self.is_running = False
    def run(self):
        self.is_running = True
        GPIO.output(CHIP_EN,1)
        while self.is_running:
            values = adc.read_adc(0, gain=GAIN)
            values = math.floor(values/SLIDER_FACTOR)
            peakValues = [165, 373, 590, 785, 1000]
            for i in peakValues:
                if values > i-50 and values < i+50:
                    if values > i+10:
                        GPIO.output(CHIP_EN, 1)
                        GPIO.output(MOTOR_RIGHT, 0)
                        GPIO.output(MOTOR_LEFT, 1)
                        #motor_right.ChangeDutyCycle(0)
                        #motor_left.ChangeDutyCycle(80)
                    elif values < i-10:
                        GPIO.output(CHIP_EN, 1)
                        GPIO.output(MOTOR_RIGHT, 1)
                        GPIO.output(MOTOR_LEFT, 0)
                        #motor_right.ChangeDutyCycle(80)
                        #motor_left.ChangeDutyCycle(0)
                    else:
                        GPIO.output(CHIP_EN, 0)
                        GPIO.output(MOTOR_RIGHT, 0)
                        GPIO.output(MOTOR_LEFT, 0)
                        motor_right.ChangeDutyCycle(0)
                        motor_left.ChangeDutyCycle(0)
                else:
                    values2 = adc.read_adc(0, gain=GAIN)
                    values2 = math.floor(values/SLIDER_FACTOR)
                    if values2>values:
                        motor_left.ChangeDutyCycle(0)
                    else:
                        GPIO.output(CHIP_EN, 0)
                        GPIO.output(MOTOR_RIGHT, 0)
                        GPIO.output(MOTOR_LEFT, 0)
                        motor_left.ChangeDutyCycle(0)
                        motor_right.ChangeDutyCycle(0)
        GPIO.output(CHIP_EN, 0)
        GPIO.output(MOTOR_RIGHT, 0)
        GPIO.output(MOTOR_LEFT, 0)

def disableChip():
    GPIO.output(CHIP_EN, 0)