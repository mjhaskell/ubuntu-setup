#!/bin/sh

read -p "Do you want to add ssh key to Github? (Y/n): " ANS
ANS=${ANS:-Y}
case $ANS in
    [yY]* )
        read -p "Enter Github username: " UNAME
        curl -u "$UNAME" --data "{\"title\":\"$UNAME\",\"key\":\"`cat $HOME/.ssh/id_ed25519.pub`\"}" https://api.github.com/user/keys;;
    * )
        echo "Not adding ssh key to Github";;
esac

exit

CUR_DIR="$(pwd)"
SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SCRIPT_DIR/.. && pwd )"

echo_green "Running test.sh"

touch blah.blah
