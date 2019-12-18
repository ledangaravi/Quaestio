# Quaestio

## Head:
All the code controlling the head can be found in the head directory.


## Website:
The index.html file in the website directory allows you to manipulate the website content. The code.js file allows you to fetch the question answers from firebase.

## Pi Mobility & Mechanical Input Methods:
All the code controlling both the mobility and the mechanical input methods can be found in the Raspberry Pi folder.
It contains two folders one for mobility and one for the mechanical input methods.

### Mobility
The mobility folder includes: ....

### Mechanical input methods
First all packages from the requirements.txt file have to be installed.
The GPIO pins used on the pi are defined in the config.py file. 

main.py is the main file which has to be executed on start-up.
testMotor.py & testButtons.py are two testfiles which can be used to test whether the buttons or slider are working.
