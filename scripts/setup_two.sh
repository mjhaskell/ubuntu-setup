#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"

INSTALL_ARR=""


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


ask_to_install "Cuda" install_cuda.sh
ask_to_install "NvidiaDriver" install_nvidia_driver.sh

ask_to_install "i3" install_i3.sh
ask_to_install "Termite" install_termite.sh

ask_to_install "Eigen" install_eigen.sh
ask_to_install "GTest" install_gtest.sh
ask_to_install "OSQP" install_osqp.sh
ask_to_install "LaTeX" install_latex.sh
ask_to_install "Lyx" install_lyx.sh
ask_to_install "VSCode" install_vscode.sh

ask_to_install "Signal" install_signal.sh
ask_to_install "Zoom" install_zoom.sh

ask_to_install "QT" install_qt.sh
ask_to_install "OpenSceneGraph" install_OSG.sh
ask_to_install "Gimp" install_gimp.sh
ask_to_install "OpenCV" install_opencv.sh
ask_to_install "ROS" install_ros_noetic.sh
ask_to_install "Holodeck" install_holodeck.sh

ask_to_install "zsh" setup_zsh.sh


# sh $SCRIPT_DIR/install_common.sh
# sh $SCRIPT_DIR/setup_sshkey.sh
# sh $SCRIPT_DIR/setup_keybindings.sh
# sh $SCRIPT_DIR/install_dotfiles.sh
# sh $SCRIPT_DIR/install_vim.sh
# sh $SCRIPT_DIR/install_pips.sh

for script in $INSTALL_ARR; do
  sh $SCRIPT_DIR/$script
done

echo_purple "You should probably reboot now"
