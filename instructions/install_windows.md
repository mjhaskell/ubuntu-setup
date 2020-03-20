# Install Windows
These are the steps for installing Windows:
1. [Create Installation Media](#create-installation-media)
2. [Create Partition Table](#create-partition-table)
3. [Format Partitions](#format-partitions)
4. [Install Windows](#install-windows)
5. [Install Linux (Optional)](#install-linux)

Note that you will need a Product Key (license) to use Windows unless you 
already have Windows installed on the machine; in that case, it will 
know that you had/have a licence when you reinstall Windows.

Also note that UEFI is better than Legacy BIOS and GPT is better than MBR
for the partition table. So, even though there is an option in Settings 
to Reset the computer (wipe hard drive and reinstall Windows), you might 
not want to use that because it might use Legacy BIOS with MBR (and the 
Reset option failed every time I tried it - but that might not be common).

## Create Installation Media (USB)
You probably need to be on a Windows machine to do this (although it might be 
possible with Wine). Follow 
[this guide](https://answers.microsoft.com/en-us/windows/forum/windows_10-windows_install/how-to-create-a-windows-10-installation-media/ad10cb15-1848-40f6-a6ad-094f902f669a) or watch
[this video](https://www.youtube.com/watch?v=1DXzr3eXkd4). The software 
downloads page can be found 
[here](https://www.microsoft.com/en-us/software-download/windows10) (only 
works on Windows machines - otherwise webpage can only download ISO).
When following the guide above, choose the option at the end to use a USB flash 
drive rather than an ISO file (you need an 8GB flash drive or bigger).

The installation media is generic for all versions of Windows 10, so you need 
to figure out which index in `sources\install.esd` matches the version you 
wand to install. After your USB flash drive is ready:
  - Open up File Explorer on Windows machine
  - Navigate to `sources` folder in flash drive
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

### Format Partitions
  - Already formatted the EFI partition while booted into Linux
  - Boot into Windows flash drive
  - Open Command Prompt as Administrator
  - `diskpart` (open disk partion menu)
  - `list disk` (display all drives - don't need but can use to verify info)
  - `list volume` (display all partitions/drives) -> use regularly to verify steps
    - Make a note of the letter assigned to your Windows flash drive (need it later)
  - `select volume <#>` (select EFI partition - should see * appear using `list volume`)
    - `format quick fs=fat32 label=System` (Don't need to do this -> did on Linux earlier)
  - `assign letter="S"` (give it a letter for easy access later)
  - `list volume` (verify changes)
  - `select volume <#>` (select Windows partition)
  - `format quick fs=ntfs label="Windows"` (format partition)
  - `assign letter="W"` (change letter to W)
  - `list volume` (verify changes)
  - `select volume <#>` (select 3GB Windows Recovery partition)
  - `format quick fs=ntfs label="Recovery Tools"` (format partition)
  - `assign letter="R"` (change letter to R)
  - `list volume` (verify changes)
  - `exit` (leave `diskpart` menu)
  
### Install Windows
  - Should still be in Command Prompt on Windows USB from formatting partitions
  - `dism /Apply-Image /ImageFile:<I>:\sources\install.esd /Index:<1> /ApplyDir:W:\`
    - Use the letter assigned to your Windows flash drive for image file (e.g. `/ImageFile:I`)
    - Use the index of the Windows version you want, 1 is Windows 10 Home (e.g. `/Index:1`)
    - Can use `install.wim` instead of `install.esd` if you created it -> index would be 1 (installer for 1 version only)
  - `W:\Windows\System32\bcdboot W:\Windows /s S:`
  - `md R:\Recovery\WindowsRE`
  - `copy W:\Windows\System32\Recovery\winre.wim R:\Recovery\WindowsRE\winre.wim`
  - `W:\Windows\System32\reagentc /setreimage /path R:\Recovery\WindowsRE /target W:\Windows`
  - `exit` (leave Command Prompt)
  - Power off and reboot into Windows partion to go through setup
    - You will need a Product Key if you didn't already have Windows on the computer
    - I selected option to not use internet for setup
    - I don't allow location services or any of the other privacy options
    - I just create local accounts rather than signing into my Microsoft account
    
### Install Linux
This is optional if you want to add a Linux partition on the same hard drive 
where you installed Windows.
  - Boot into Ubuntu flash drive and open Terminal
  - `lsblk` (figure out which device you want put Linux on)
  - `sudo gdisk /dev/<sda>` (use the device you found)
  - `p` (print - should see the EFI and 3 Windows partitions)
  - `n` (create new partition)
  - `ENTER` (use default partition #)
  - `+32M` (leave 32MB empty space after last partition)
  - `-64M` (go until 64MB left on drive - don't use the last little bit)
  - `8300` (Linux filesystem)
  - `p` (print - verify changes)
  - `w` (write changes)
  - `systemctl poweroff` (reboot after writing to partition table)
  - Boot into Ubuntu flash drive and run installer
    - When option comes up to install Ubuntu, select "Something else" for manual control
    - Format your Linux partition as ext4 and mount to /
