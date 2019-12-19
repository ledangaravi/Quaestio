# Quaestio

## Head:
All the code controlling the head can be found in the head directory.
*quaestio.py* is the main file, which has to be executed on start-up using python3.
*quastio_constants.py* the pins used on the pi are defined.

## Hypothesis Testing:
This folder contains both the dataset collected *survey_data.json* as well as the notebook *Hypothesis_Testing.ipynb* used for the analysis of the gathered data.

## Website:
The index.html file in the website directory allows you to manipulate the website content. The code.js file allows you to fetch the question answers from firebase.

## Mechanical Input Methods & Mobility:
All the code controlling both the mobility and the mechanical input methods can be found in this folder.

### Mobility
For the ROS Kinetic Ubuntu is installed on the Raspberry Pi, this is due to the fact that ROS Kinetic only supports Wily (Ubuntu 15.10), Xenial (Ubuntu 16.04) and Jessie (Debian 8) for debian packages. After setting up the pi with the system the following [tutorial](http://wiki.ros.org/ROSberryPi/Installing%20ROS%20Kinetic%20on%20the%20Raspberry%20Pi) can be followed in order to install and use ROS Kinetic.

### Mechanical input methods
First all packages from the *requirements.txt* file have to be installed using pip3.
The GPIO pins used on the pi are defined in the *config.py* file. 

*main.py* is the main file which has to be executed on start-up using python3.
*testMotor.py* & *testButtons.py* are two testfiles which can be used to test whether the buttons and slider are working.

An ssh key linked to the account used for github can be put into the pi folder in order to allow the pi to automatically pull the latest master version from the github repository. This is done by updating on Firebase the field: Hardware_Interface\Current_State.

#### An overview of the threads can be seen here:
![Threads](https://github.com/ledangaravi/Quaestio/blob/master/Schematics/ButtonSetUp.png)

## Quaestio-Admin-App
All the code for the admin app can be found in the Admin App folder.

### Main Menu
![MainMenu](https://user-images.githubusercontent.com/31923016/70916473-a69d1000-2013-11ea-8b67-fc2280e68029.png)

### New Setup
![NewSetup](https://user-images.githubusercontent.com/31923016/70916615-e5cb6100-2013-11ea-9b9b-c3cbcb873023.png)

### Manage Setups
![ManageSetup](https://user-images.githubusercontent.com/31923016/70916613-e5cb6100-2013-11ea-94c2-e6827fd31d02.png)

### Dashboard
![Dashboard](https://user-images.githubusercontent.com/31923016/70916616-e663f780-2013-11ea-88f1-d75482c42ce6.png)

### Control & Maintenance
![Control](https://user-images.githubusercontent.com/31923016/70916619-e663f780-2013-11ea-952e-c8fa3406c9d3.png)

### Human-Led Surveys
![survey0](https://user-images.githubusercontent.com/31923016/70916611-e5cb6100-2013-11ea-8ac7-5cce527ab6d9.png)
![survey1](https://user-images.githubusercontent.com/31923016/70916612-e5cb6100-2013-11ea-8ab0-041633b496b1.png)
![survey2](https://user-images.githubusercontent.com/31923016/70916617-e663f780-2013-11ea-9910-c0b029aaff41.png)
![survey3](https://user-images.githubusercontent.com/31923016/70916621-e6fc8e00-2013-11ea-9a82-4d5a747b6c78.png)
![survey4](https://user-images.githubusercontent.com/31923016/70917280-f0d2c100-2014-11ea-9c7f-d57aec01f34e.png)

