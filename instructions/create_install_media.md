# Create Installation Media (USB)

## Linux
1. Download image file: Google search "\<distro> \<flavor> iso" (e.g. "ubuntu 22.04 budgie iso") and
    you should find it easily enough
1. Plug in the USB you wish to use (make sure it has enough space to hold the image file)
1. Figure out what device the USB drive is on (e.g. `/dev/sda`) by running `lsblk`
1. Flash the USB (or partition) with the image file: `sudo dd if=<image file>.iso of=/dev/<device> oflag=sync conv=fdatasync bs=4M status=progress`
1. Now you can boot into that USB

## Windows
You probably need to be on a Windows machine to do this (although it might be
possible with Wine). Follow
[this guide](https://answers.microsoft.com/en-us/windows/forum/windows_10-windows_install/how-to-create-a-windows-10-installation-media/ad10cb15-1848-40f6-a6ad-094f902f669a) or watch
[this video](https://www.youtube.com/watch?v=1DXzr3eXkd4). The software
downloads page can be found
[here](https://www.microsoft.com/en-us/software-download/windows10) (only
works on Windows machines - otherwise webpage can only download ISO).
When following the guide above, choose the option at the end to use a USB flash
drive rather than an ISO file (you need an 8GB flash drive or bigger).
If you are comfortable enough with computers, just download the ISO and
[Rufus](https://rufus.ie/) (I prefer the "portable" version). Use Rufus to
flash your USB flash drive with the ISO image, deselecting the option that says
something to the effect of "create auto start files".

Once the image is flashed to the USB flash drive, the installation media is
generic for all versions of Windows 10, so you need
to figure out which index in `sources\install.esd` matches the version you
want to install. After your USB flash drive is ready:
  - Open up File Explorer on a Windows machine
  - Navigate to the `sources` folder on your flash drive
  - Click `File` -> `Open Windows PowerShell (as administrator)`
  - `dism /Get-WimInfo /WimFile:install.esd` (list all indices)

Here are the results when I did this:
```bash
Index 1: Windows 10 Home
Index 2: Windows 10 Home N
Index 3: Windows 10 Home Single Language
Index 4: Windows 10 Education
Index 5: Windows 10 Education N
Index 6: Windows 10 Pro
Index 7: Windows 10 Pro N
```

This Index is important and will be used later. Note down the index number
pertaining to the license you previously had on your computer, or for which
you bought a retail license.

If you want to create an installer for 1 specific index:
  - `dism /export-image /SourceImageFile:install.esd /SourceIndex:<choose index #> /DestinationImageFile:install.wim /Compress:max /CheckIntegrity`
  - (do not include <> when choosing the index number, e.g. `/SourceIndex:1`)
  - Be careful how much memory you have when creating `install.wim` (~4GB for Index 1)
