# Install Windows
These are the steps for installing Windows:
1. [Create Installation Media](#create-installation-media)
2. [Create Partition Table](#create-partition-table)
3. [Install Windows](#)

Note that you will need a Product Key (license) to use Windows unless you 
already have Windows installed on the machine; in that case, it will 
know that you had/have a licence when you reinstall Windows.

## Create Installation Media (USB)
You probably need to be on a Windows machine to do this (although it might be 
possible with Wine). Follow 
[this guide](https://answers.microsoft.com/en-us/windows/forum/windows_10-windows_install/how-to-create-a-windows-10-installation-media/ad10cb15-1848-40f6-a6ad-094f902f669a) or watch
[this video](https://www.youtube.com/watch?v=1DXzr3eXkd4). The software 
downloads page can be found 
[here](https://www.microsoft.com/en-us/software-download/windows10).
When following the guide above, choose the option at the end to use a USB flash 
drive rather than an ISO file (you need an 8GB flash drive or bigger).

The installation media is generic for all versions of Windows 10, so you need 
to figure out which index in `sources\install.esd` matches the version you 
wand to install. After your USB flash drive is ready:
  - Open up File Explorer on Windows machine
  - Navigate to sources folder in flash drive
  - Click File -> Open Windows PowerShell (as administrator)
  - `dism /Get-WimInfo /WimFile:install.esd` (list all indices)
Here are the results when I did this:
  - Index 1: Windows 10 Home
  - Index 2: Windows 10 Home N
  - Index 3: Windows 10 Home Single Language
  - Index 4: Windows 10 Education
  - Index 5: Windows 10 Education N
  - Index 6: Windows 10 Pro
  - Index 7: Windows 10 Pro N
This Index is important and will be used later.

If you want to create an installer for 1 specific index:
  - `dism /export-image /SourceImageFile:install.esd /SourceIndex:<choose index #> /DestinationImageFile:install.wim /Compress:max /CheckIntegrity`
  - (don't include <> when choosing the index number, e.g. `/SourceIndex:1`)
  - Be careful how much memory you have when creating `install.wim` (~4GB for Index 1)

## Create Partition Table
If you are going to use Windows and Linux on the same hard drive, then create 
partitions for Windows first.

### 1. Zap (erase) current partition table
  - Boot into Ubuntu flash drive and open Terminal
  - `lsblk` (figure out which device corresponds to the drive)
  - `sudo gdisk /dev/<sda>` (substitute sda with device found above)
  - `x` (get into expert menu)
  - `z` (zap the drive - you will have to say yes to a couple of things)
### 2. Create new partition table (GPT)
  - Should still be in Ubuntu Terminal
  - `sudo gdisk /dev/<sda>`
  - `o` (creates new table)
  - `w` (write changes)
  - `systemctl poweroff` (power off after writing changes)
### 3. Add partitions for EFI and Windows
  - Boot into Ubuntu flash drive and open Terminal
  - `sudo gdisk /dev/<sda>` (same device as before)
  - `n` (create new partition)
  - `ENTER` (use default partition #)
  - `ENTER` (use default start location)
  - `+256M` (allocate next 256MB for partition)
  - `ef00` (EFI)
  - `n` (create new partition)
  - `ENTER` (use default partition #)
  - `+32M` (leave 32MB empty space after last partition)
  - `+16M` (allocate next 16MB for partition)
  - `0c01` (Microsoft reserved)
  - `n` (create new partition)
  - `ENTER` (use default partition #)
  - `+32M` (leave 32MB empty space after last partition)
  - `+<500G>` (choose size for Windows partition)
  - `0700` (Windows basic data)
  - `n` (create new partition)
  - `ENTER` (use default partition #)
  - `+32M` (leave 32MB empty space after last partition)
  - `+3G` (allocate 3GB for partition)
  - `2700` (Windows Recovery)
  - `p` (print table and verify it is correct)
  - `w` (write changes)
  - `sudo mkfs.vfat /dev/<sda1> -n ESP` (Format EFI partition you just made)
  - `systemctl poweroff` (reboot after writing to partition table)
