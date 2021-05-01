#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SCRIPT_DIR/.. && pwd )"

INSTALL_ARR="install_pips.sh"

ask_to_install()
{
  APP=$1
  FILE=$2

  read -p "Do you want to install $APP? (Y/n): " ANS
  ANS=${ANS:-Y} # sets Y to be default value
  case $ANS in
    [yY]* ) # if first letter is y or Y (yes)
      INSTALL_ARR="${INSTALL_ARR} $FILE";;
      # INSTALL=1;;
    * ) # anything else
      ;;
      # INSTALL=0;;
  esac
  # return $INSTALL
}

ask_to_install "LaTeX" install_latex.sh
INSTALL_LATEX=$?

ask_to_install "Eigen" install_eigen.sh
INSTALL_EIGEN=$?

ask_to_install "OpenSceneGraph" install_OSG.sh
INSTALL_OSG=$?

ask_to_install "Gimp" install_gimp.sh
INSTALL_GIMP=$?

ask_to_install "Lyx" install_lyx.sh
INSTALL_LYX=$?

ask_to_install "GTest" install_gtest.sh
INSTALL_GTEST=$?

ask_to_install "OpenCV" install_opencv.sh
INSTALL_OPENCV=$?

ask_to_install "ROS" install_ros_noetic.sh
INSTALL_ROS=$?

echo_red "computer will now power off"
reboot
