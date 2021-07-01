# Set up bluetooth

## Using Desktop Environment
If you are using a desktop environment (Gnome, Budgie, etc.) then bluetooth should just work out of the box using the settings GUI.

## No Desktop Environment
If you are not using desktop environment and instead only using a window mangager like i3, here is how you can use bluetooth with cli.
These are the sources I used to get bluetooth working:
  - https://simpleit.rocks/linux/shell/connect-to-bluetooth-from-cli
  - https://unix.stackexchange.com/questions/258074/error-when-trying-to-connect-to-bluetooth-speaker-org-bluez-error-failed

### Steps
1. Identify bluetooth devices (commands in order from least info to most)
  - `hcitool dev`
  - `hciconfig`
  - `hciconfig -a`
2. Open bluetooth menu
  - `bluetoothctl`
3. Commands inside menu
  - `power on`
  - `agent on`
  - `default-agent`
  - `discoverable on`
  - `pairable on`
  - `scan on`
    - Look for your device as it scans
  - `scan off`
  - `trust XX:XX:XX:XX:XX:XX`
  - `pair XX:XX:XX:XX:XX:XX`
  - `connect XX:XX:XX:XX:XX:XX`
    - Try connecting and pairing a couple of times if it doesn't work

### Troubleshooting
I ran into issues using a bluetooth USB adapter at first.
I used this [repo] to install the right firmware.
If using an adapter that is not made by broadcom then you might need to search online.

You can see if you have an error with the following:
1. Show bluetooth info from dmesg
  - `dmesg | grep -i bluetooth`
  - `dmesg | grep -i bluetooth | grep -i firmware`
  - `dmesg | grep hci1`
    - Need to know which device (hci0, hci1, etc.)
2. If you see a message that says "Direct firmware load for brcm/*.hcd failed with error -2"
  - Look for matching file name in `/lib/firmware/brcm/`
  - Download matching hrc file from [repo] and move it into `/lib/firmware/brcm/`
  - Reboot
3. Try `dmesg` commands again to see if there is still a firmware error
4. Now try using `bluetoothctl` to connect to device
  - Might need to restart bluetooth.service and bluetooth.target using `systemctl`

<!-- links -->
[repo]: https://github.com/winterheart/broadcom-bt-firmware
