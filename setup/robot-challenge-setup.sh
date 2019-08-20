#!/bin/bash

# Debug - Break on error
set -e

# Hack: Clear any file locks
sudo rm -f /var/lib/apt/lists/lock

# Color it
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'

# Time it
scriptstart=$(date +%s)

#
# ROS image for Sawyer development
#

# Time it
start=$(date +%s)
#
#

#dev only
if true; then

# author="Sergey Smolnikov (satr.github.io@gmail.com)"
# description="Adoption to ROS Melodic and Ubuntu 18. Forked from autored Paul Stubbs (pstubbs@microsoft.com) Microsoft Robot Challenge 2018"
# version="1.0"

# Install some common CLI tools
sudo apt-get update -y
sudo apt-get install -y wget software-properties-common

#
#
#
# Install Bot Framework + Emulator
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nInstall bot framework + Emulator\n***\n***\n***\n***"
echo -e ${NC}

sudo apt-get update
# install unmet dependencies
sudo apt-get -f install -y
sudo apt-get -f install libindicator7 -y
sudo apt-get -f install libappindicator1 -y
# install any unmet dependencies
sudo apt-get -f install -y

fi
#dev only
if true; then


#Get emulator app
rm -f ../resources/BotFramework-Emulator*.AppImage
wget 'https://github.com/microsoft/BotFramework-Emulator/releases/download/v4.5.2/BotFramework-Emulator-4.5.2-linux-x86_64.AppImage' \
  -O ../resources/BotFramework-Emulator.AppImage
sudo chmod +x ../resources/BotFramework-Emulator.AppImage


# install any unmet dependencies
sudo apt-get -f install -y
sudo apt autoremove -y

# Ubuntu 18 already have Python 3.6
# Install Python 3.6
#echo -e ${GREEN}
#echo -e "***\n***\n***\n***\nInstall Python 3.6\n***\n***\n***\n***"
#echo -e ${NC}
#sudo add-apt-repository -y ppa:deadsnakes/ppa
#sudo apt-get update -y
#sudo apt-get install -y python3.6
#sudo apt-get install -y python3-pip
#sudo ln -sf /usr/bin/python3.6 /usr/bin/python

#Add env to bash
#echo "export PYTHONPATH=/usr/local/lib/python3.6" >> ~/.bashrc
#source ~/.bashrc

# install any unmet dependencies
#sudo apt-get -f install -y
# Install pip
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nInstall pip\n***\n***\n***\n***"
echo -e ${NC}
#Fiollowing line is for troubleshooting only - when it is not happen to install pip
#sudo python3 -m pip uninstall pip -y && sudo apt install python3-pip --reinstall -y
sudo apt install --upgrade python3-pip -y
#alias pip=pip3

fi
#dev only
if true; then

# Install Bot Framework Deps
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nInstall bot framework Dependencies\n***\n***\n***\n***"
echo -e ${NC}

python3.6 -m pip install --user aiohttp
python3.6 -m pip install --user requests
python3.6 -m pip install --user botbuilder.schema
python3.6 -m pip install --user botbuilder.core

# Time it
end=$(date +%s)
runtime=$(python -c "print('{0}:{1}'.format((${end} - ${start})/60, (${end} - ${start})%60))")
echo -e ${BLUE}
echo -e "Elapsed Time: ${runtime}"
echo -e ${NC}
fi
#dev only
if true; then

#
#
#
# Install ROS
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nInstall ROS\n***\n***\n***\n***"
echo -e ${NC}
# Time it
start=$(date +%s)
#
#
# http://sdk.rethinkrobotics.com/intera/Workstation_Setup

# Update to lateset software lists
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nUpdate to lateset software lists\n***\n***\n***\n***"
echo -e ${NC}

# Configure Ubuntu repositories. Setup sources.list
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# Setup keys
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Install ROS Melodic Desktop FUll
echo -e ${GREEN}
echo -e "***\n***\n***\n***\n Install ROS Melodic Desktop FUll \n***\n***\n***\n***"
echo -e ${NC}

sudo apt-get update -y
sudo apt install ros-melodic-desktop-full -y

# Initialize rosdep
sudo rosdep init || echo -e "${YELLOW}ROSDep Already Exists.${NC}"
rosdep update

#Install missed components from RethinkingRobotics
#http://nu-msr.github.io/embedded-course-site/notes/baxter_introduction.html#sawyer-build-instructions
cd .. #down from "setup"
mkdir -p sawyerws/src
cd sawyerws/src/
wstool init
wstool merge https://gist.githubusercontent.com/jarvisschultz/f65d36e3f99d94a6c3d9900fa01ee72e/raw/sawyer_packages.rosinstall
wstool update
cd ../../setup #back to "setup"

source /opt/ros/melodic/setup.bash
catkin_make
#Add env to bash
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

#Install missed components
python3 -m pip install catkin_pkg
sudo apt install python3-empy -y

# Install rosinstall
sudo apt install python-rosinstall python-rosinstall-generator python-wstool build-essential -y

# Time it
end=$(date +%s)
runtime=$(python -c "print('{0}:{1}'.format((${end} - ${start})/60, (${end} - ${start})%60))")
echo -e ${BLUE}
echo -e "Elapsed Time: ${runtime}"
echo -e ${NC}

#dev only
fi
if true; then


#
#
#
# Create Development Workspace
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nCreate Development Workspace\n***\n***\n***\n***"
echo -e ${NC}
# Time it
start=$(date +%s)
#
#
#
#Add the path to ROS
echo "source ~/ros_ws/devel/setup.bash" >> ~/.bashrc


# Create ROS Workspace
rm -rf ~/ros_ws
mkdir -p ~/ros_ws/src
cd ~/ros_ws
source /opt/ros/melodic/setup.bash
catkin_make --cmake-args # -DPYTHON_VERSION=3.6


# Time it
end=$(date +%s)
runtime=$(python -c "print('{0}:{1}'.format((${end} - ${start})/60, (${end} - ${start})%60))")
echo -e ${BLUE}
echo -e "Elapsed Time: ${runtime}"
echo -e ${NC}


#
#
#
# Install Intera SDK Dependencies
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nInstall Intera SDK Dependencies\n***\n***\n***\n***"
echo -e ${NC}
# Time it
start=$(date +%s)
#
#
#

# Install SDK Dependencies
# Update to lateset software lists

sudo apt-get update
sudo apt-get install -y --allow-unauthenticated \
  git-core \
  python-argparse \
  python-wstool \
  python-vcstools \
  python-rosdep \
  ros-melodic-control-msgs \
  ros-melodic-joystick-drivers \
  ros-melodic-xacro \
  ros-melodic-tf2-ros \
  ros-melodic-rviz \
  ros-melodic-cv-bridge \
  ros-melodic-actionlib \
  ros-melodic-actionlib-msgs \
  ros-melodic-dynamic-reconfigure \
  ros-melodic-trajectory-msgs \
  ros-melodic-rospy-message-converter

# Time it
end=$(date +%s)
runtime=$(python -c "print('{0}:{1}'.format((${end} - ${start})/60, (${end} - ${start})%60))")
echo -e ${BLUE}
echo -e "Elapsed Time: ${runtime}"
echo -e ${NC}

#
#
#
# Install Intera Robot SDK
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nInstall Intera Robot SDK\n***\n***\n***\n***"
echo -e ${NC}
# Time it
start=$(date +%s)
#
#
#

cd ~/ros_ws/src
wstool init .
git clone https://github.com/RethinkRobotics/sawyer_robot.git
wstool merge sawyer_robot/sawyer_robot.rosinstall
wstool update

# Source ROS Setup
cd ~/ros_ws
source /opt/ros/melodic/setup.bash
catkin_make

# Time it
end=$(date +%s)
runtime=$(python -c "print('{0}:{1}'.format((${end} - ${start})/60, (${end} - ${start})%60))")
echo -e ${BLUE}
echo -e "Elapsed Time: ${runtime}"
echo -e ${NC}


#
#
#
# Configure Robot Communication/ROS Workspace
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nConfigure Robot Communication/ROS Workspace\n***\n***\n***\n***"
echo -e ${NC}
# Time it
start=$(date +%s)
#
#
#

# Copy the intera.sh script
# The intera.sh file already exists in intera_sdk repo, 
# copy the file into your ros workspace.
cp ~/ros_ws/src/intera_sdk/intera.sh ~/ros_ws

# Update the copy of the intera.sh file
# cd ~/ros_ws
# Update ROS Distribution
sed -i 's/ros_version="indigo"/ros_version="melodic"/' ~/ros_ws/intera.sh
# Update the ROBOTS hostname
sed -i 's/robot_hostname="robot_hostname.local"/robot_hostname="paule.local"/' ~/ros_ws/intera.sh

# TODO:// Need to figure out the docker networking to resolve hostname
# Update YOUR IP or Hostname. This must be resolvable to the Robot
# Choose one. Be sure to add or remove the leading # from the right ones
sed -i 's/your_ip="192.168.XXX.XXX"/your_ip="192.168.XXX.XXX"/' ~/ros_ws/intera.sh
#sed -i 's/#your_hostname="my_computer.local"/your_hostname="my_computer.local"/' intera.sh

# Setup and configure RVIZ
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nSetup and configure RVIZ\n***\n***\n***\n***"
echo -e ${NC}
# TODO:// need to do this still

# Time it
end=$(date +%s)
runtime=$(python -c "print('{0}:{1}'.format((${end} - ${start})/60, (${end} - ${start})%60))")
echo -e ${BLUE}
echo -e "Elapsed Time: ${runtime}"
echo -e ${NC}


# http://sdk.rethinkrobotics.com/intera/Gazebo_Tutorial
#
#
#
# Configure Sawyer with Gazebo
#
#
#

# Install Prerequisites
# Update to lateset software lists
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nUpdate to lateset software lists\n***\n***\n***\n***"
echo -e ${NC}
# Time it
start=$(date +%s)
#
#
#
sudo apt-get update -y
sudo apt-get install -y --allow-unauthenticated \
  gazebo9 \
  ros-melodic-gazebo-ros-control \
  ros-melodic-gazebo-ros-pkgs \
  ros-melodic-ros-control \
  ros-melodic-control-toolbox \
  ros-melodic-realtime-tools \
  ros-melodic-ros-controllers \
  ros-melodic-xacro \
  python-wstool \
  ros-melodic-tf-conversions \
  ros-melodic-kdl-parser

#TODO not found
#  ros-melodic-qt-build \
#  ros-melodic-sns-ik-lib
#  git clone https://github.com/RethinkRobotics-opensource/sns_ik.git
# cd sns_ik\snk_ik_lib && mkdir build && cd build && cmake -DUSEWX=yes -DCMAKE_BUILD_TYPE=Release .. && make -j4
# sudo cp -r devel/share/sns_ik_lib /opt/ros/melodic/share
# sudo cp ../package.xml /opt/ros/melodic/share/snk_ik_lib/

# Install Sawyer Simulator files
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nInstall Sawyer Simulator files\n***\n***\n***\n***"
echo -e ${NC}

cd ~/ros_ws/src
if [ ! -d src/sawyer_simulator ]
then
  # folder does not exist so clone the repo
	echo -e ${YELLOW}
  echo "~/ros_ws/src/sawyer_simulator folder does not exist, cloning now"
  echo -e ${NC}
  git clone https://github.com/RethinkRobotics/sawyer_simulator.git
else
  # folder does exist so pull to update
	echo -e ${YELLOW}
  echo "~/ros_ws/src/sawyer_simulator folder already exists, updating now"
  echo -e ${NC}
  cd ~/ros_ws/src/sawyer_simulator
  git pull
  cd ~/ros_ws/src
fi
source /opt/ros/melodic/setup.bash 
wstool merge sawyer_simulator/sawyer_simulator.rosinstall
wstool update

# Build the Sources
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nSDK Build the Sources\n***\n***\n***\n***"
echo -e ${NC}
source /opt/ros/melodic/setup.bash
cd ~/ros_ws
catkin_make

fi
#dev only
if true; then

# Time it
end=$(date +%s)
runtime=$(python -c "print('{0}:{1}'.format((${end} - ${start})/60, (${end} - ${start})%60))")
echo -e ${BLUE}
echo -e "Elapsed Time: ${runtime}"
echo -e ${NC}


#
#
#
# Install other tools
#
#
#

#
#
#
# Install Chromium Browser
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nInstall Chromium Browser\n***\n***\n***\n***"
echo -e ${NC}
# Time it
start=$(date +%s)
#
#
#
#https://www.linuxbabe.com/ubuntu/install-google-chrome-ubuntu-16-04-lts
sudo su -c "echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list"
TEMP_DEB="$(mktemp)"
wget -O "$TEMP_DEB" 'https://dl.google.com/linux/linux_signing_key.pub'
sudo apt-key add "$TEMP_DEB"
rm -f "$TEMP_DEB"
sudo apt-get update
sudo apt-get install google-chrome-stable


# Time it
end=$(date +%s)
runtime=$(python -c "print('{0}:{1}'.format((${end} - ${start})/60, (${end} - ${start})%60))")
echo -e ${BLUE}
echo -e "Elapsed Time: ${runtime}"
echo -e ${NC}


#
#
#
# Install Visual Studio Code
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nInstall Visual Studio Code\n***\n***\n***\n***"
echo -e ${NC}
# Time it
start=$(date +%s)
#
#
#
#https://tecadmin.net/install-visual-studio-code-editor-ubuntu/
sudo su -c "echo 'deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main' >> /etc/apt/sources.list.d/vscode.list"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo apt-get update
sudo apt-get install code

#dev only
fi

# Time it
end=$(date +%s)
runtime=$(python -c "print('{0}:{1}'.format((${end} - ${start})/60, (${end} - ${start})%60))")
echo -e ${BLUE}
echo -e "Elapsed Time: ${runtime}"
echo -e ${NC}

#
#
#
# Update the machine
echo -e ${GREEN}
echo -e "***\n***\n***\n***\nUpdate the Machine\n***\n***\n***\n***"
echo -e ${NC}
#
#
#
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# Time it
start=${scriptstart}
end=$(date +%s)
runtime=$(python -c "print('{0}:{1}'.format((${end} - ${start})/60, (${end} - ${start})%60))")
echo -e ${BLUE}
echo -e "Total Elapsed Time: ${runtime}"
echo -e ${NC}
