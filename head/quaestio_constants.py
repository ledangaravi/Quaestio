# servo channel numbers
EYE_LEFT_HORIZONTAL     =  0
EYE_LEFT_VERTICAL       =  1
EYE_LEFT_LID_LOWER      =  2
EYE_LEFT_LID_UPPER      =  3
EYE_LEFT_EYEBROW        =  4
EAR_LEFT                =  5
MOUTH                   =  6
NECK_ROTATE             =  7
NECK_TILT               =  8
EYE_RIGHT_HORIZONTAL    =  9
EYE_RIGHT_VERTICAL      = 10
EYE_RIGHT_LID_LOWER     = 11
EYE_RIGHT_LID_UPPER     = 12
EYE_RIGHT_EYEBROW       = 13
EAR_RIGHT               = 14

# angle limits:
MID_ANGLE = 90
EYE_HORIZONTAL_MIN    = 60      # look left
EYE_HORIZONTAL_MAX    = 120     # look right
EYE_VERTICAL_MIN      = 50      # look up,      needs invert
EYE_VERTICAL_MAX      = 130     # look down,    needs invert
EYE_LID_LOWER_MIN     = 50      # closed,       needs invert
EYE_LID_LOWER_MAX     = 130     # open,         needs invert
EYE_LID_UPPER_MIN     = 50      # closed,       needs invert
EYE_LID_UPPER_MAX     = 130     # open,         needs invert

EYE_LID_LOWER_CLOSED  = 65  # needs invert
EYE_LID_UPPER_CLOSED  = 65  # needs invert

EYE_EYEBROW_MIN = 60    #outwards,  needs invert
EYE_EYEBROW_MAX = 120   #inwards,   needs invert

MOUTH_CLOSED    = 85
MOUTH_OPEN      = 150

EAR_FRONT   = 135   # needs invert
EAR_BACK    = 45    # needsd invert

NECK_TILT_LEVEL = 90
NECK_TILT_DOWN = 110
NECK_TILT_UP = 40

EYELIDS_ANGLE = 50


# LED
EYE_LEFT_LED    = 0
EYE_RIGHT_LED   = 1

LEDS_OFF        = (0,0,0)
LEDS_MAX        = (65535,65535,65535)
LEDS_RED        = (65535,0,0)
LEDS_GREEN      = (0,65535,0)
LEDS_BLUE       = (0,0,65535)
LEDS_YELLOW     = (65535,65535,0)
LEDS_MAGENTA    = (65535,0,65535)
LEDS_NEUTRAL    = (14080, 55040, 54272)