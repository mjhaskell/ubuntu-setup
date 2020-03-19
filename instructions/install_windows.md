# Install Windows
These are the steps for installing Windows:
1. [Create Installation Media](#create-installation-media)
2. [Create Partition Table](#create-partition-table)
3. [Install Windows](#)

## Create Installation Media (USB)
You probably need to be on a Windows machine to do this (although it might be 
possible with Wine). Follow 
[this guide](https://answers.microsoft.com/en-us/windows/forum/windows_10-windows_install/how-to-create-a-windows-10-installation-media/ad10cb15-1848-40f6-a6ad-094f902f669a) or watch
[this video](https://www.youtube.com/watch?v=1DXzr3eXkd4). The software 
downloads page can be found 
[here](https://www.microsoft.com/en-us/software-download/windows10).
When following the guide above, choose the option at the end to use a USB flash 
drive rather than an ISO file (it says you need an 8GB flash drive - mine only 
used ~3.5GB).

After your USB flash drive is ready:

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
  - `sudo gdisk /dev/<sda>`
  - `o` (creates new table)
  - `w` (write changes)
  - `systemctl poweroff` (power off after writing changes)
### 3. Add partitions for EFI and Windows
  - `sudo gdisk /dev/<sda>`
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
