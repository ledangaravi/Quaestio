# todo refactor to
# def _init__(self, kit, channel):
#     self.face_element = kit.servo[channel]
#
# todo refactor all angles to %

import quaestio_constants as qc
import random
import board
import busio
import adafruit_tlc59711
from time import sleep, time
from multiprocessing import Process, Value
from adafruit_servokit import ServoKit
from firebase_access import getFirebaseValue, setFirebaseValue

class QuaestioEye:

    def __init__(self, kit, eye_horizontal, eye_vertical, eyelid_lower, eyelid_upper, eyebrow, invert=False):
        self.driver = kit
        self.eye_horizontal = eye_horizontal
        self.eye_vertical = eye_vertical
        self.eyelid_lower = eyelid_lower
        self.eyelid_upper = eyelid_upper
        self.eyebrow = eyebrow
        self.invert = invert
        self.compensation = 3
        self.home()

    def home(self):
        self.driver.servo[self.eye_horizontal].angle = qc.MID_ANGLE
        self.driver.servo[self.eye_vertical].angle = qc.MID_ANGLE
        self.driver.servo[self.eyelid_lower].angle = qc.MID_ANGLE
        if self.invert:
            self.driver.servo[self.eyelid_upper].angle = qc.MID_ANGLE
        else:
            self.driver.servo[self.eyelid_upper].angle = qc.MID_ANGLE + self.compensation
        self.driver.servo[self.eyebrow].angle = qc.MID_ANGLE


    def close(self):
        if self.invert:
            self.driver.servo[self.eyelid_lower].angle = self.__invert(qc.EYE_LID_LOWER_CLOSED)
            self.driver.servo[self.eyelid_upper].angle = self.__invert(qc.EYE_LID_UPPER_CLOSED)
        else:
            self.driver.servo[self.eyelid_lower].angle = qc.EYE_LID_LOWER_CLOSED
            self.driver.servo[self.eyelid_upper].angle = qc.EYE_LID_UPPER_CLOSED

    def open(self):
        if self.invert:
            self.driver.servo[self.eyelid_lower].angle = qc.EYE_LID_LOWER_MIN
            self.driver.servo[self.eyelid_upper].angle = qc.EYE_LID_UPPER_MIN
        else:
            self.driver.servo[self.eyelid_lower].angle = qc.EYE_LID_LOWER_MAX
            self.driver.servo[self.eyelid_upper].angle = qc.EYE_LID_UPPER_MAX

    def eyelids_track(self, angle=qc.EYELIDS_ANGLE, offset=0):
        eyelid_lower_closed = qc.EYE_LID_LOWER_CLOSED
        eyelid_upper_closed = qc.EYE_LID_UPPER_CLOSED
        if self.invert:
            eyelid_lower_closed = self.__invert(qc.EYE_LID_LOWER_CLOSED)
            eyelid_upper_closed = self.__invert(qc.EYE_LID_UPPER_CLOSED)
            angle = -angle
            offset = -offset
        eye_vertical = int(self.driver.servo[self.eye_vertical].angle) + offset
        eyelid_lower_angle = self.__clamp(eyelid_lower_closed - (qc.MID_ANGLE - eye_vertical) + angle / 2)
        eyelid_upper_angle = self.__clamp(eyelid_upper_closed + (qc.MID_ANGLE - eye_vertical) + angle / 2)
        self.driver.servo[self.eyelid_lower].angle = eyelid_lower_angle
        if not self.invert:
            eyelid_upper_angle += self.compensation
        self.driver.servo[self.eyelid_upper].angle = eyelid_upper_angle

    def blink(self, delay=0.1):
        eyelid_lower_angle = self.driver.servo[self.eyelid_lower].angle
        eyelid_upper_angle = self.driver.servo[self.eyelid_upper].angle
        self.close()
        sleep(delay)
        self.driver.servo[self.eyelid_lower].angle = eyelid_lower_angle
        self.driver.servo[self.eyelid_upper].angle = eyelid_upper_angle

    def look(self, horizontal, vertical, eyelids_tracking=True, eyelids_angle=qc.EYELIDS_ANGLE):
        eye_horizontal = self.__clamp(horizontal, qc.EYE_HORIZONTAL_MIN, qc.EYE_HORIZONTAL_MAX)
        eye_vertical = self.__clamp(vertical, qc.EYE_VERTICAL_MIN, qc.EYE_VERTICAL_MAX)
        if self.invert:
            eye_vertical = self.__invert(eye_vertical)
        self.driver.servo[self.eye_horizontal].angle = eye_horizontal
        self.driver.servo[self.eye_vertical].angle = eye_vertical
        if eyelids_tracking:
            self.eyelids_track(angle=eyelids_angle)

    def eyebrow_angle(self, angle):
        if self.invert:
            angle = self.__invert(angle)
        self.driver.servo[self.eyebrow].angle = angle

    def eyebrow_sweep(self, speed=1, delay=1):
        current = int(self.driver.servo[self.eyebrow].angle)
        for angle in range(current, qc.EYE_EYEBROW_MIN, -speed):
            self.driver.servo[self.eyebrow].angle = angle
        sleep(delay)
        for angle in range(qc.EYE_EYEBROW_MIN, qc.EYE_EYEBROW_MAX, speed):
            self.driver.servo[self.eyebrow].angle = angle
        sleep(delay)
        for angle in range(qc.EYE_EYEBROW_MAX, current, -speed):
            self.driver.servo[self.eyebrow].angle = angle
        sleep(delay)


    # def random_look(self, blink_frequency=5, eyelids_tracking=True, repeat=1, interval=1, home=True):
    #     for _ in range(repeat):
    #         eye_horizontal = random.randint(qc.EYE_HORIZONTAL_MIN, qc.EYE_HORIZONTAL_MAX)
    #         eye_vertical = random.randint(qc.EYE_VERTICAL_MIN, qc.EYE_VERTICAL_MAX)
    #         self.driver.servo[self.eye_horizontal].angle = eye_horizontal
    #         self.driver.servo[self.eye_vertical].angle = eye_vertical
    #         if eyelids_tracking:
    #             self.eyelids_track()
    #         if (blink_frequency > 0) and (random.randint(0, blink_frequency - 1) == 0):
    #             self.blink()
    #         sleep(interval)
    #     if home:
    #         self.home()

    def __clamp(self, n, minn=qc.EYE_VERTICAL_MIN, maxn=qc.EYE_VERTICAL_MAX):
        if n < minn:
            return minn
        elif n > maxn:
            return maxn
        else:
            return n

    def __invert(self, x, y=qc.MID_ANGLE):
        return (y - x) * 2 + x

class QuaestioEyes:

    def __init__(self, kit):
        self.driver = kit
        self.eye_left = QuaestioEye(self.driver, qc.EYE_LEFT_HORIZONTAL, qc.EYE_LEFT_VERTICAL, qc.EYE_LEFT_LID_LOWER, qc.EYE_LEFT_LID_UPPER,qc.EYE_LEFT_EYEBROW)
        self.eye_right = QuaestioEye(self.driver, qc.EYE_RIGHT_HORIZONTAL, qc.EYE_RIGHT_VERTICAL, qc.EYE_RIGHT_LID_LOWER, qc.EYE_RIGHT_LID_UPPER,qc.EYE_RIGHT_EYEBROW, invert=True)
        self.spi = busio.SPI(board.SCK, MOSI=board.MOSI)
        self.leds = adafruit_tlc59711.TLC59711(self.spi, auto_show=False)
        self.home()

    def home(self):
        self.eye_left.home()
        self.eye_right.home()
        self.color(qc.LEDS_NEUTRAL)

    def open(self):
        self.eye_left.open()
        self.eye_right.open()

    def close(self):
        self.eye_left.close()
        self.eye_right.close()

    def eyelids_track(self, angle=qc.EYELIDS_ANGLE, offset=0):
        self.eye_left.eyelids_track(angle, offset)
        self.eye_right.eyelids_track(angle, offset)

    def blink(self, delay=0.1, repeat=1, pause=0):
        for _ in range(repeat):
            eyelid_lower_left_angle = self.driver.servo[self.eye_left.eyelid_lower].angle
            eyelid_upper_left_angle = self.driver.servo[self.eye_left.eyelid_upper].angle
            eyelid_lower_right_angle = self.driver.servo[self.eye_right.eyelid_lower].angle
            eyelid_upper_right_angle = self.driver.servo[self.eye_right.eyelid_upper].angle
            self.eye_left.close()
            self.eye_right.close()
            sleep(delay)
            self.driver.servo[self.eye_left.eyelid_lower].angle = eyelid_lower_left_angle
            self.driver.servo[self.eye_left.eyelid_upper].angle = eyelid_upper_left_angle
            self.driver.servo[self.eye_right.eyelid_lower].angle = eyelid_lower_right_angle
            self.driver.servo[self.eye_right.eyelid_upper].angle = eyelid_upper_right_angle
            sleep(pause)

    def horizontal_sweep(self, speed=1, reverse=False, delay=0.2, eyelids_tracking=True, eyelids_angle=qc.EYELIDS_ANGLE):
        current = int(self.driver.servo[self.eye_left.eye_horizontal].angle)
        vertical = int(self.driver.servo[self.eye_left.eye_vertical].angle)
        for horizontal in range(current, qc.EYE_HORIZONTAL_MIN, -speed):
            self.look(horizontal, vertical, eyelids_tracking, eyelids_angle)
        sleep(delay)
        for horizontal in range(qc.EYE_HORIZONTAL_MIN, qc.EYE_HORIZONTAL_MAX, speed):
            self.look(horizontal, vertical, eyelids_tracking, eyelids_angle)
        sleep(delay)
        for horizontal in range(qc.EYE_HORIZONTAL_MAX, current, -speed):
            self.look(horizontal, vertical, eyelids_tracking, eyelids_angle)
        sleep(delay)

    def vertical_sweep(self, speed=1, reverse=False, delay=0.2, eyelids_tracking=True, eyelids_angle=qc.EYELIDS_ANGLE):
        horizontal = int(self.driver.servo[self.eye_left.eye_horizontal].angle)
        current = int(self.driver.servo[self.eye_left.eye_vertical].angle)
        for vertical in range(current, qc.EYE_VERTICAL_MIN, -speed):
            self.look(horizontal, vertical, eyelids_tracking, eyelids_angle)
        sleep(delay)
        for vertical in range(qc.EYE_VERTICAL_MIN, qc.EYE_VERTICAL_MAX, speed):
            self.look(horizontal, vertical, eyelids_tracking, eyelids_angle)
        sleep(delay)
        for vertical in range(qc.EYE_VERTICAL_MAX, current, -speed):
            self.look(horizontal, vertical, eyelids_tracking, eyelids_angle)
        sleep(delay)

    def roll(self, speed=5, eyelids_tracking=True, eyelids_angle=qc.EYELIDS_ANGLE):
        self.look(qc.MID_ANGLE, qc.EYE_VERTICAL_MAX, eyelids_tracking, eyelids_angle)
        for horizontal in range(qc.EYE_HORIZONTAL_MIN, qc.EYE_HORIZONTAL_MAX, speed):
            self.look(horizontal, qc.EYE_VERTICAL_MAX, eyelids_tracking, eyelids_angle)
        for vertical in range(qc.EYE_VERTICAL_MAX, qc.EYE_VERTICAL_MIN, -speed):
            self.look(qc.EYE_HORIZONTAL_MAX, vertical, eyelids_tracking, eyelids_angle)
        for horizontal in range(qc.EYE_HORIZONTAL_MAX, qc.EYE_HORIZONTAL_MIN, -speed):
            self.look(horizontal, qc.EYE_VERTICAL_MIN, eyelids_tracking, eyelids_angle)
        for vertical in range(qc.EYE_VERTICAL_MIN, qc.EYE_VERTICAL_MAX, speed):
            self.look(qc.EYE_HORIZONTAL_MIN, vertical, eyelids_tracking, eyelids_angle)
        self.home()

    def eyebrows(self, angle):
        self.eye_left.eyebrow_angle(angle)
        self.eye_right.eyebrow_angle(angle)

    def eyebrow_sweep(self, speed=1, delay=1):
        current = int(self.driver.servo[self.eye_left.eyebrow].angle)
        for angle in range(current, qc.EYE_EYEBROW_MIN, -speed):
            self.eyebrows(angle)
        sleep(delay)
        for angle in range(qc.EYE_EYEBROW_MIN, qc.EYE_EYEBROW_MAX, speed):
            self.eyebrows(angle)
        sleep(delay)
        for angle in range(qc.EYE_EYEBROW_MAX, current, -speed):
            self.eyebrows(angle)
        sleep(delay)

    def look(self, horizontal, vertical, eyelids_tracking=True, eyelids_angle=qc.EYELIDS_ANGLE):
        self.eye_left.look(horizontal, vertical, eyelids_tracking, eyelids_angle)
        self.eye_right.look(horizontal, vertical, eyelids_tracking, eyelids_angle)

    def random_look(self, blink_delay=0.1, blink_frequency=5, eyelids_tracking=True, eyelids_angle=qc.EYELIDS_ANGLE, repeat=1, interval=0, home=True):
        for _ in range(repeat):
            eye_horizontal = random.randint(qc.EYE_HORIZONTAL_MIN, qc.EYE_HORIZONTAL_MAX)
            eye_vertical = random.randint(qc.EYE_VERTICAL_MIN, qc.EYE_VERTICAL_MAX)
            self.look(eye_horizontal, eye_vertical, eyelids_tracking, eyelids_angle)
            if (blink_frequency > 0) and (random.randint(0, blink_frequency - 1) == 0):
                self.blink(delay=blink_delay)
            sleep(interval)
        if home:
            self.home()

    def color(self, rgb=None, random_color=False, brightness=127, random_brightness=False, repeat=1, delay=0):
        if rgb is None:
            rgb = self.leds[qc.EYE_LEFT_LED]
        for _ in range(repeat):
            if random_color:
                r = random.randint(0,65535)
                g = random.randint(0,65535)
                b = random.randint(0,65535)
                rgb = (r,g,b)
            elif random_brightness:
                brightness = random.randint(16,127)
            self.leds[qc.EYE_LEFT_LED] = rgb
            self.leds[qc.EYE_RIGHT_LED] = rgb
            self.leds.red_brightness = brightness
            self.leds.green_brightness = brightness
            self.leds.blue_brightness = brightness
            self.leds.show()
            sleep(delay)

class QuaestioMouth:

    def __init__(self, kit, mouth):
        self.driver = kit
        self.mouth = mouth
        self.home()

    def home(self):
        self.close()

    def open(self):
        self.driver.servo[self.mouth].angle = qc.MOUTH_OPEN

    def close(self):
        self.driver.servo[self.mouth].angle = qc.MOUTH_CLOSED

    def offset(self, offset):   # todo clamp
        self.driver.servo[self.mouth].angle = qc.MOUTH_CLOSED + offset

    def random(self, offset=0): #todo check offset
        mouth_position = random.randint(qc.MOUTH_CLOSED + offset, qc.MOUTH_OPEN)
        self.driver.servo[self.mouth].angle = mouth_position

class QuaestioEar:

    def __init__(self, kit, ear, invert=False):
        self.driver = kit
        self.ear = ear
        self.invert = invert
        self.home()

    def __off(self):
        sleep(0.2)
        self.driver.servo[self.ear].set_pulse_width_range(0,1)
        self.driver.servo[self.ear].angle = 90

    def off(self):
        p = Process(target=self.__off)
        p.start()

    def on(self):
        self.driver.servo[self.ear].set_pulse_width_range(min_pulse=750, max_pulse=2250)

    def home(self):
        self.on()
        self.driver.servo[self.ear].angle = qc.MID_ANGLE
        self.off()

    def front(self):
        self.on()
        if self.invert:
            self.driver.servo[self.ear].angle = qc.EAR_BACK
        else:
            self.driver.servo[self.ear].angle = qc.EAR_FRONT
        self.off()

    def back(self):
        self.on()
        if self.invert:
            self.driver.servo[self.ear].angle = qc.EAR_FRONT
        else:
            self.driver.servo[self.ear].angle = qc.EAR_BACK
        self.off()

    def offset(self, angle):    #todo map
        self.on()
        if self.invert:
            self.driver.servo[self.ear].angle = qc.MID_ANGLE - angle
        else:
            self.driver.servo[self.ear].angle = qc.MID_ANGLE + angle
        self.off()

class QuaestioEars:

    def __init__(self, kit):
        self.driver = kit
        self.ear_left = QuaestioEar(self.driver, qc.EAR_LEFT)
        self.ear_right = QuaestioEar(self.driver, qc.EAR_RIGHT, invert=True)

    def home(self):
        self.ear_left.home()
        self.ear_right.home()

    def front(self):
        self.ear_left.front()
        self.ear_right.front()

    def back(self):
        self.ear_left.back()
        self.ear_right.back()

    def offset(self, angle):    #todo map
        self.ear_left.offset(angle)
        self.ear_right.offset(angle)

    def sweep(self, delay=0.5, repeat=1):
        for _ in range(repeat):
            self.ear_left.front()
            self.ear_right.front()
            sleep(delay)
            self.ear_left.back()
            self.ear_right.back()
            sleep(delay)
        self.ear_left.home()
        self.ear_right.home()

    def flapping(self, delay=0.5, repeat=1):
        for _ in range(repeat):
            self.ear_left.front()
            self.ear_right.back()
            sleep(delay)
            self.ear_left.back()
            self.ear_right.front()
            sleep(delay)
        self.ear_left.home()
        self.ear_right.home()

class QuaestioNeck:

    def __init__(self, kit, rotate, tilt):
        self.driver = kit
        self.rotate = rotate
        self.tilt = tilt
        self.home()

    def home(self):
        self.driver.servo[self.tilt].angle = qc.NECK_TILT_LEVEL
        self.driver.continuous_servo[self.rotate].throttle = 0

    def tilt_angle(self, angle):
        # self.driver.servo[self.tilt].angle = angle
        sleep(0.01)

    def rotate_throttle(self, throttle):
        self.driver.continuous_servo[self.rotate].throttle = throttle

    def nod(self, speed=2, delay=0.05, bottom_offset=5, top_offset=10, repeat=1):
        current_position = int(self.driver.servo[self.tilt].angle)
        bottom_position = qc.NECK_TILT_DOWN - bottom_offset
        top_position = qc.NECK_TILT_UP + top_offset
        for _ in range(repeat):
            for tilt_angle in range(current_position, bottom_position, speed):
                # self.driver.servo[self.tilt].angle = tilt_angle
                sleep(delay)
            for tilt_angle in range(bottom_position, top_position, -speed):
                # self.driver.servo[self.tilt].angle = tilt_angle
                sleep(delay)
            for tilt_angle in range(top_position, current_position, speed):
                # self.driver.servo[self.tilt].angle = tilt_angle
                sleep(delay)

    def shake(self, speed=0.05, duration=0.5):
        self.driver.continuous_servo[self.rotate].throttle = speed
        sleep(duration)
        self.driver.continuous_servo[self.rotate].throttle = -speed
        sleep(2 * duration)
        self.driver.continuous_servo[self.rotate].throttle = speed
        sleep(duration)
        self.driver.continuous_servo[self.rotate].throttle = 0

    def spin(self):
        self.driver.continuous_servo[self.rotate].throttle = -0.1
        sleep(4.3)
        self.driver.continuous_servo[self.rotate].throttle = 0

    def tilt_to(self, angle, speed=1, delay=0.05):
        current = int(self.driver.servo[self.tilt].angle)
        if current > angle:
            speed = -speed
        for tilt in range(current, angle, speed):
            self.tilt_angle(tilt)
            sleep(0.1)

class Quaestio:

    def __init__(self):
        self.driver = ServoKit(channels=16)
        self.neck = QuaestioNeck(self.driver, qc.NECK_ROTATE, qc.NECK_TILT)
        self.mouth = QuaestioMouth(self.driver, qc.MOUTH)
        self.eyes = QuaestioEyes(self.driver)
        self.ears = QuaestioEars(self.driver)

        self.talk = Value('i',0)
        self.idle = Value('i',0)
        self.idle_process = Process(target=self.__idling, args=(self.idle,))
        self.idle_process.start()

    def home(self, mouth=True):
        self.neck.home()
        self.eyes.home()
        self.ears.home()
        if mouth:
            self.mouth.home()

    def __speak_timed(self, talk, delay):
        # idle_reenable = bool(q.idle.value)
        # self.idle_disable()
        # self.home()
        delay = int(delay)
        start_time = time()
        while(talk.value == 1 and time() < start_time + delay):
            self.mouth.random()
            sleep(0.1)
            self.mouth.close()
        talk.value = 0
        # if idle_reenable:
        #     self.idle_enable()

    def speak(self, delay=5):
        speak_process = Process(target=self.__speak_timed, args=(self.talk, delay))
        self.talk.value = 1
        speak_process.start()

    def expression(self, state):
        idle_reenable = bool(self.idle.value)
        self.idle_disable()
        # self.talk.value = 0
        self.home(mouth=False)
        sleep(0.2)

        if state == 'angry':
            self.angry()
        elif state == 'annoyed':
            self.annoyed()
        elif state == 'celebrate':
            self.celebrate()
        elif state == 'ears_flapping':
            self.ears_flapping()
        elif state == 'flirt':
            self.flirt()
        elif state == 'happy':
            self.happy()
        elif state == 'headspin':
            self.headspin()
        elif state == 'sad':
            self.sad()
        elif state == 'sleeping':
            self.sleeping()
        elif state == 'surprised':
            self.surprised()
        elif state == 'suspicious':
            self.suspicious()
        elif state == 'wink':
            self.wink()
        elif state == 'demo':
            self.demo()
        elif state == 'idle_enable':
            idle_reenable = True
        elif state == 'idle_disable':
            idle_reenable = False
        elif state == 'servos_disable':
            self.servos_disable()
        elif state == 'servos_enable':
            self.servos_enable()
        elif state not in ['done', 'off']:
            print('Unknown face state: "' + state + '"')

        sleep(1)
        self.home(mouth=False)
        if idle_reenable:
            self.idle_enable()


    def servos_enable(self):
        for i in range(16):
            if i == qc.NECK_ROTATE:
                self.driver.continuous_servo[i].set_pulse_width_range(min_pulse=750, max_pulse=2250)
            else:
                self.driver.servo[i].set_pulse_width_range(min_pulse=750, max_pulse=2250)
        self.home()

    def servos_disable(self):
        for i in range(16):
            if i == qc.NECK_ROTATE:
                self.driver.continuous_servo[i].set_pulse_width_range(0,1)
                self.driver.continuous_servo[i].throttle = 0
            else:
                self.driver.servo[i].set_pulse_width_range(0,1)
                self.driver.servo[i].angle = 0

    def idle_enable(self):
        self.idle.value = 1

    def idle_disable(self):
        self.idle.value = 0

    def idle_stop(self):
        self.idle_disable()
        self.idle_process.join(timeout=0)
        self.idle_process.terminate()

    def __idling(self, idle):
        look_freq = 2
        blink_freq = 2
        tilt_freq = 4
        ear_freq = 6
        mouth_freq = 7
        # rotate_freq = 3
        min_delay = 1
        max_delay = 3
        while True:
            if idle.value == 1:
                if random.randint(0, look_freq-1) == 0:
                    eyebrow_angle = random.randint(qc.EYE_EYEBROW_MIN, qc.EYE_EYEBROW_MAX - 10)
                    self.eyes.color(random_brightness=True)
                    self.eyes.eyebrows(eyebrow_angle)
                    self.eyes.random_look(home=False, eyelids_angle=random.randint(30,50), blink_frequency=0)
                if random.randint(0, blink_freq-1) == 0:
                    self.eyes.blink()
                if random.randint(0, tilt_freq-1) == 0:
                    tilt_angle = random.randint(qc.NECK_TILT_LEVEL-10, qc.NECK_TILT_LEVEL+10)
                    self.neck.tilt_angle(tilt_angle)
                if random.randint(0, ear_freq-1) == 0:
                    offset = random.randint(-20, 20)
                    self.ears.offset(offset)
                if random.randint(0, mouth_freq-1) == 0:
                    self.mouth.random(offset=10)
                else:
                    self.mouth.close()
                # if random.randint(0, rotate_freq-1) == 0:
                #     duration = random.randint(1,5) / 10
                #     self.neck.shake(duration=duration)
            delay = random.randint(min_delay, max_delay)
            sleep(delay)

    def demo(self):
        delay = 2

        self.angry()
        sleep(delay)
        self.home()
        sleep(delay)

        self.annoyed()
        sleep(delay)
        self.home()
        sleep(delay)

        self.celebrate()
        sleep(delay)
        self.home()
        sleep(delay)

        self.ears_flapping()
        sleep(delay)
        self.home()
        sleep(delay)

        self.flirt()
        sleep(delay)
        self.home()
        sleep(delay)

        self.happy()
        sleep(delay)
        self.home()
        sleep(delay)

        # self.headspin()
        # sleep(delay)
        # self.home()
        # sleep(delay)

        self.sad()
        sleep(delay)
        self.home()
        sleep(delay)

        self.sleeping()
        sleep(delay)
        self.home()
        sleep(delay)

        self.surprised()
        sleep(delay)
        self.home()
        sleep(delay)

        self.suspicious()
        sleep(delay)
        self.home()
        sleep(delay)

        self.wink()

    def angry(self):
        ''' mouth small movements, eyes narrow, ears forwards, eyebrows in '''
        leds_p = Process(target=self.eyes.color, args=(qc.LEDS_RED, False, 127, True, 16, 0.25))
        leds_p.start()
        self.eyes.eyebrows(qc.EYE_EYEBROW_MAX)
        self.eyes.eyelids_track(angle=qc.EYELIDS_ANGLE - 10)
        self.ears.front()
        self.speak(3)
        leds_p.join()
        leds_p.terminate()

    def annoyed(self):
        ''' eyes roll, eyebrows asymmetric, eyelids closer, ears front '''
        self.ears.offset(30)
        self.eyes.eye_left.eyebrow_angle(110)
        self.eyes.eye_right.eyebrow_angle(70)
        self.eyes.eyelids_track(qc.EYELIDS_ANGLE + 20)
        self.eyes.roll(speed=2, eyelids_tracking=False)
        self.eyes.eyelids_track(qc.EYELIDS_ANGLE - 15)

    def celebrate(self):
        ''' headspin, nod, eyes wide, ears flapping, eyebrows out '''
        self.wink()
        sleep(1)
        nod_p = Process(target=self.neck.nod, args=(4, 0.05, 0, 30, 2))
        earflap_p = Process(target=self.ears.flapping, args=(0.5, 4))
        shake_p = Process(target=self.neck.shake, args=(0.05, 0.5))
        blink_p = Process(target=self.eyes.blink, args=(0.1, 10, 0.2))
        leds_p = Process(target=self.eyes.color, args=((0,0,0), True, 127, False, 32, 0.2))

        leds_p.start()
        nod_p.start()
        earflap_p.start()
        nod_p.join()
        blink_p.start()
        shake_p.start()

        leds_p.join()
        earflap_p.join()
        shake_p.join()
        blink_p.join()

        leds_p.terminate()
        nod_p.terminate()
        earflap_p.terminate()
        shake_p.terminate()
        blink_p.terminate()

    def ears_flapping(self):
        ''' ears move around '''
        self.ears.flapping(delay=0.5, repeat=1)

    def flirt(self):
        ''' look up and down, wink, ears flapping '''
        self.wink()
        sleep(1)
        self.eyes.vertical_sweep()
        self.ears.flapping()
        sleep(1)
        self.wink()

    def happy(self):
        ''' look slightly up, quick blink, eyebrows outwards, ears backwards, neck tilt up '''
        self.eyes.color(qc.LEDS_MAX)
        self.neck.tilt_angle(qc.NECK_TILT_LEVEL - 10)
        self.eyes.eyebrows(80)
        self.ears.offset(-20)
        self.eyes.eyelids_track(qc.EYELIDS_ANGLE + 10, offset=-10)
        self.mouth.offset(10)
        self.eyes.blink()

    def headspin(self):
        ''' head spins around '''
        self.neck.spin()

    def sad(self):
        ''' look down, slow blink, tilt head down, eyebrows slightly outwards, ears slightly forwards '''
        self.eyes.color(rgb=qc.LEDS_NEUTRAL, brightness=32)
        self.eyes.eyebrows(80)
        self.eyes.look(qc.MID_ANGLE, qc.EYE_VERTICAL_MAX)
        self.ears.offset(20)
        current_neck_tilt = int(self.driver.servo[self.neck.tilt].angle)
        p = Process(target=self.eyes.blink, args=(1,))
        p.start()
        for angle in range(current_neck_tilt, 95, 1):
            self.neck.tilt_angle(angle=angle)
            sleep(0.05)
        p.join()
        p.terminate()

    def sleeping(self):
        ''' head down, eyes closed, '''
        self.eyes.color(rgb=qc.LEDS_NEUTRAL, brightness=96)
        self.eyes.blink(delay=0.2)
        self.eyes.eyelids_track(angle=qc.EYELIDS_ANGLE-5)
        sleep(1)
        self.eyes.color(rgb=qc.LEDS_NEUTRAL, brightness=64)
        self.eyes.blink(delay=0.6)
        self.eyes.eyelids_track(angle=qc.EYELIDS_ANGLE-10)
        sleep(3)
        self.eyes.color(rgb=qc.LEDS_NEUTRAL, brightness=32)
        self.eyes.blink(delay=1)
        self.eyes.eyelids_track(angle=qc.EYELIDS_ANGLE-15)
        sleep(2)
        p = Process(target=self.neck.tilt_to, args=(qc.NECK_TILT_DOWN, 1, 0.05))
        p.start()
        self.eyes.color(rgb=qc.LEDS_NEUTRAL, brightness=16)
        self.eyes.blink(delay=1.4)
        self.eyes.eyelids_track(angle=qc.EYELIDS_ANGLE-20)
        sleep(1)
        self.eyes.color(rgb=qc.LEDS_OFF)
        self.eyes.close()
        p.join()
        p.terminate()

    def surprised(self):
        ''' mouth open, eyelids open, ears backwards '''
        self.eyes.color(qc.LEDS_YELLOW)
        self.mouth.open()
        self.eyes.open()
        self.ears.back()
        self.neck.tilt_angle(qc.NECK_TILT_LEVEL - 10)

    def suspicious(self):
        ''' eyes narrow look, sweep horizontal, eyebrows inwards '''
        self.eyes.color(rgb=qc.LEDS_MAGENTA, brightness=64)
        self.eyes.eyebrows(100)
        self.eyes.horizontal_sweep(eyelids_angle=qc.EYELIDS_ANGLE - 10)

    def wink(self, delay=0.3):
        self.eyes.eyelids_track(qc.EYELIDS_ANGLE + 10)
        sleep(0.2)
        self.eyes.eye_right.eyebrow_angle(80)
        self.eyes.eye_left.eyebrow_angle(60)
        self.eyes.eye_right.eyelids_track(angle=qc.EYELIDS_ANGLE + 20)
        self.mouth.offset(20)
        self.eyes.eye_left.blink(delay=delay)
        self.home()

def is_number(s):
    try:
        int(s)
        return True
    except ValueError:
        return False

if __name__ == '__main__':
    q = Quaestio()
    expression_p = Process(target=q.expression)
    sleep(1)
    q.wink()
    face_state = 'done'
    setFirebaseValue("Face_State", face_state)
    idle = False
    expression = False
    print("Quaestio is ready")
    while True:
        new_face_state = getFirebaseValue("Face_State")
        if new_face_state not in [face_state]:
            if new_face_state == 'done':
                face_state = new_face_state
            else:
                face_state = new_face_state
                if face_state in ['quit', 'shutdown', 'refresh']:
                    setFirebaseValue("Face_State","off")
                    q.idle_stop()
                    q.home()
                    q.sleeping()
                    q.servos_disable()
                    q.eyes.color(qc.LEDS_OFF)
                    break
                if expression_p.is_alive():
                    expression_p.join(timeout=0)
                    expression_p.terminate()
                    expression_p = None
                expression = True
                p = Process(target=q.expression, args=(face_state,))
                expression_p = p
                expression_p.start()
                # q.expression(face_state)
                # setFirebaseValue("Face_State","done")

        if not expression_p.is_alive() and expression:
            expression = False
            setFirebaseValue("Face_State","done")

        audio = getFirebaseValue("Audio")
        if audio != 0 and is_number(audio):
            setFirebaseValue("Audio", 0)
            q.speak(delay=audio)
        elif audio in ['end', 'End']:
            q.talk.value = 0

        if getFirebaseValue("Current_State") == 'Welcome':
            if not idle:
                idle = True
                q.idle_enable()
        else:
            if idle:
                idle = False
                q.idle_disable()
                q.home()


    if face_state == 'shutdown':
        import os
        os.system("sudo shutdown -h now")
    elif face_state == 'refresh':
        from subprocess import Popen
        Popen('/home/pi/stuff/quaestio_git_pull.sh', shell=True, stdin=None, stdout=None, stderr=None)

