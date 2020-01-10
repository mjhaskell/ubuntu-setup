#!/bin/bash

echo_blue "Setting up keybindings"

# need this alias for script to work
keybind='gsettings set org.gnome.desktop.wm.keybindings'

$keybind switch-to-workspace-1 "['<super>1']"
$keybind switch-to-workspace-2 "['<super>2']"
$keybind switch-to-workspace-3 "['<super>3']"
$keybind switch-to-workspace-4 "['<super>4']"
$keybind switch-to-workspace-5 "['<super>5']"
$keybind switch-to-workspace-6 "['<super>6']"
$keybind switch-to-workspace-7 "['<super>7']"
$keybind switch-to-workspace-8 "['<super>8']"
$keybind switch-to-workspace-9 "['<super>9']"

$keybind move-to-workspace-1 "['<ctrl><super>1']"
$keybind move-to-workspace-2 "['<ctrl><super>2']"
$keybind move-to-workspace-3 "['<ctrl><super>3']"
$keybind move-to-workspace-4 "['<ctrl><super>4']"
$keybind move-to-workspace-5 "['<ctrl><super>5']"
$keybind move-to-workspace-6 "['<ctrl><super>6']"
$keybind move-to-workspace-7 "['<ctrl><super>7']"
$keybind move-to-workspace-8 "['<ctrl><super>8']"
$keybind move-to-workspace-9 "['<ctrl><super>9']"

$keybind move-to-side-n "['<alt>k']"
$keybind move-to-side-e "['<alt>l']"
$keybind move-to-side-s "['<alt>j']"
$keybind move-to-side-w "['<alt>h']"

$keybind move-to-monitor-up      "['<shift><super>k']"
$keybind move-to-monitor-right   "['<shift><super>l']"
$keybind move-to-monitor-down    "['<shift><super>j']"
$keybind move-to-monitor-left    "['<shift><super>h']"

$keybind move-to-workspace-up    "['<ctrl><super>k']"
$keybind move-to-workspace-right "['<ctrl><super>l']"
$keybind move-to-workspace-down  "['<ctrl><super>j']"
$keybind move-to-workspace-left  "['<ctrl><super>h']"

$keybind switch-to-workspace-right "['<super>k']"
$keybind switch-to-workspace-left  "['<super>j']"

$keybind close "['<ctrl><alt>q']"
$keybind show-desktop "['<super>d']"

echo_green "Keybindings set up"
