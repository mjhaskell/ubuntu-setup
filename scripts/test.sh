#!/bin/sh

CUR_DIR="$(pwd)"
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
      # INSTALL=1
      # echo_blue "Going to install $APP";;
    * ) # anything else
      ;;
      # INSTALL=0
      # echo "Not going to install $APP";;
  esac
  # return $INSTALL
}

ask_to_install Eigen install_eigen.sh
APP1=$?

ask_to_install CMake install_cmake.sh
APP2=$?

echo "APP1: $APP1"
echo "APP2: $APP2"

for value in $INSTALL_ARR; do
  echo $value
done

exit

if [ "$APP1" -gt "0" ]; then
  echo_green "Installing $APP1"
else
  echo_red "Not installing $APP1"
fi

if [ "$APP2" -gt "0" ]; then
  echo_green "Installing $APP2"
else
  echo_red "Not installing $APP2"
fi
