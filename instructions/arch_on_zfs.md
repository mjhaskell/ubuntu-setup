# Install Arch on ZFS

## Step 1: Partition drive

EFI, Windows, and swap partitions must all be separate

My Partitions (if including Windows):

- EFI: EF00, 10G
- Microsoft reserved: 0C01, 16M
- Microsoft basic data (ntfs): 0700, split space with linux/zfs partition
- Windows Recovery: 2700, 10G
- FreeBSD ZFS: A504, split space with Windows (**Arch only**)
- ext4: 8300, split space with Windows (**for Ubuntu**)
- Linux swap: 8200, at least 2x ram (I did 100G on 2T drive)

## Step 2: Create zpool on ZFS partition

#### Get unique ID of partition

Need to get the unique ID of partition (use the ID that says samsung not sabrent).
This makes it so that you don't have to worry about it being sda or sdb, or changing whenever you plug it in.
I will have to change this once it is installed into my computer because the beginning of the name will change from "ata" to "nvme".

```sh
ls -alh /dev/disk/by-id
```

#### Figure out ashift

I should probably learn more about it, but the drive has a register size that I want to match.
In general, it seems better to go up rather than down if you aren't quite sure.
Apparently, the [samsung 990 pro] has 128k registers but they "act" smaller where maybe ashift=9 is OK, but [this](link) said to use 12 to be more future proof.

ashift values:

- 12: 4k
- 13: 8k
- 14: 16k

```sh
sudo zpool create \
    -o ashift=12 \ # verify ashift (see above)
    -o autotrim=on \ # automatically optimistically trim physical drive
    -R /mnt \ # specify alternate root directory (to temporarily mount at /mnt)
    -O xattr=sa \ # extended attributes set to sa
    -O compression=zstd-5 \ # default compression type (media: lz4, root pool: zstd-5, home pool: zstd-7 or higher)
    -O atime=off \ # access time
    -O relatime=off \ # relative access time
    -O recordsize=512K \ # default is 128K (Jim Salter says 1M for most things), datasets can change this later
    -O normalization=formD \ # read in docs
    -O dnodesize=auto \
    -O canmount=off \
    -O mountpoint=none \ # same as "-m none"
    nempool0 \ # give it a name "nemesis zpool 0"
    # single \ # specify vdev type ## this didn't work
    /dev/disk/by-id/<disk or partition specifier> # ata-Samsung-990-Pro-<serial> (comes from /dev/disk/by-id)
```

!!! note

    If the drive is plugged in over USB, you will need to change the disk-id after installing it internally.
    Use a global identifier, such as `wwn*` or `nvme-eui*`.

## Step 3: Create vdevs

Can add more, but the creating the zpool with a device automatically adds it as a vdev.

## Step 4: Create an encryption password

Go to Bitwarden and create a secure password.
Create a file and put the password in it.
Note where you save the file `/path/<nem_pool0_root>.key` (perhaps `/zfs-keys/<name>.key`)

## Step 5: Create datasets

#### Create root container dataset with no mounting

```sh
sudo zfs create \
    -o encryption=aes-256-gcm \
    -o keylocation=file://<full path (start with another /) on active device where you saved a password>.key \
    -o keyformat=passphrase \
    -o mountpoint=none -o canmount=off \
    nempool0/nemroot # name it
```

#### Create OS root dataset mounted at /

```sh
sudo zfs create -o mountpoint=/ -o canmount=noauto nempool0/nemroot/arch
```

#### Create OS home dataset mounted at /home

```sh
sudo zfs create \
    -o encryption=aes-256-gcm \
    -o keylocation=file://<full path (start with another /) on active device where you saved a password>.key \
    -o keyformat=passphrase \
    -o mountpoint=/home \
    -o recordsize=1M \
    -o compression=zstd-5 \ # may want higher
    nempool0/nemhome
```

#### Unmount all datasets

```sh
sudo zfs umount -a
```

#### Test it

```sh
sudo zpool export nemroot
sudo zpool import -N -R /mnt nempool0
sudo zfs list # should be unavailable
sudo zfs load-key nempool0/nemroot
sudo zfs list # should be available now
sudo zfs mount nempool0/nemroot/arch
sudo zfs mount nempool0/nemhome
sudo mount | grep mnt # make sure it is mounted properly
```

## Step 6: Install OS (arch)

#### (Create) and mount EFI partition

```sh
# sudo mkfs.vfat ...
sudo mkdir /mnt/efi
sudo mount /dev/<efi partition identifier> /mnt/efi
```

#### Copy arch onto drive

```sh
sudo pacstrap /mnt base base-devel linux-lts linux-firmware linux-lts-headers dkms vim openssh rsync man-pages man-db pacman-contrib git curl zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions tmux iwd openresolv > pacstrap_<hostname>.log # zfs-dkms zfs-utils zfsbootmenu
```

??? note "Note on linux-firmware"

    Query missing firmware (not through live disk - on installed internal drive):

    ```sh
    sudo dmesg | grep -i firmware
    ```

    Can install all `linux-firmware` or individual components:

    - linux-firmware-amdgpu
    - linux-firmware-atheros
    - linux-firmware-broadcom
    - linux-firmware-cirrus
    - linux-firmware-intel
    - linux-firmware-mediatek
    - linux-firmware-nvidia
    - linux-firmware-other
    - linux-firmware-radeon
    - linux-firmware-realtek

    Optional:

    - linux-firmware-liquidio: Firmware for Cavium LiquidIO server adapters
    - linux-firmware-marvell: Firmware for Marvell devices
    - linux-firmware-mellanox: Firmware for Mellanox Spectrum switches
    - linux-firmware-nfp: Firmware for Netronome Flow Processors
    - linux-firmware-qcom: Firmware for Qualcomm SoCs
    - linux-firmware-qlogic: Firmware for QLogic devices

#### Watch the magic.

## Step 7: Copy files to new system

```sh
cp /etc/hostid /mnt/etc/.
cp /etc/resolv.conf /mnt/etc/.
mkdir /mnt/zfs-keys
cp /zfs-keys/<name>.key /mnt/zfs-keys/.
cp /etc/pacman.conf /mnt/etc/pacman.conf
```

## Step 8: Generate /etc/fstab

```sh
sudo genfstab /mnt > /mnt/etc/fstab
```

#### Open generated file and delete all lines but the one with /efi

## Step 9: Chroot into new system and do basic setup

```sh
sudo arch-chroot /mnt
```

#### Set time zone

```sh
ln -sf /usr/share/zoneinfo/US/Mountain /etc/localtime
hwclock --systohc
```

#### Generate locales

```sh
vim /etc/locale.gen ## uncomment all locales you need, e.g., en_US.UTF-8 UTF-8
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
```

#### Set hostname

```sh
echo '<hostname>' > /etc/hostname
echo '127.0.0.1   localhost' >> /etc/hosts
echo '::1         localhost' >> /etc/hosts
echo '127.0.1.1   <hostname>.home.arpa <hostname>' >> /etc/hosts
```

#### Install ZFS packages from AUR

- `zfs-utils`
- `zfs-dkms`
- `zfsbootmenu`

```sh
mkdir ~/aur_pkgs && cd ~/aur_pkgs
git clone https://aur.archlinux.org/zfs-utils
git clone https://aur.archlinux.org/zfs-dkms
git clone https://aur.archlinux.org/zfsbootmenu
cd zfs-utils
mkpkg -s
cd ../zfs-dkms
mkpkg -s
cd ..
sudo pacman -U zfs-utils/<file>.tar zfs-dkms/<file>.tar
cd zfsbootmenu
mkpkg -si
```

## Step 10: Install refind

```sh
pacman -S refind
cp -r /usr/share/refind /efi/EFI/.
cp <old_computer>/refind.conf /efi/EFI/refind/.
```

#### Follow [option 2](#option-2-use-refind-to-boot-into-zfsbootmenu-allows-dual-boot) in step 14 below

## Step 11: Generate initramfs

```sh
vim /etc/mkinitcpio.conf
```

#### Change the `FILES` line to (use created key file):

```txt
<!-- FILES=(/etc/zfs/keys/nem_pool0_root.key) -->
<!-- FILES=(/etc/zfs/nem_pool0_root.key) -->
FILES=(/etc/zfs/np0k.k)
```

OR

```sh
echo 'FILES+=(/etc/zfs/keys/nem_pool0_root.key)' >> /etc/mkinitcpio.conf
```

#### Change the `HOOKS` line to (use created key file):

```txt
<!-- HOOKS=(base udev autodetect modconf block keyboard zfs filesystems) -->
HOOKS=(base udev keyboard autodetect microcode modconf kms keymap block zfs filesystems fsck)
<!-- CAN NOT ADD "zfsbootmenu" -->
```

#### Generate initramfs

```sh
sudo mkinitcpio -P
```

## Step 12: Setup users

#### Set root password (and record it in Bitwarden)

```sh
passwd
```

#### Create user and give it a password

```sh
useradd -m -s /usr/bin/zsh <username>
passwd <username>
```

## Step 12: Set bootfs

```sh
zpool set bootfs=nempool0/nemroot/arch nempool0
```

#### Enable all needed daemons

```sh
systemctl enable zfs-import.target zfs.target
systemctl enable zfs-mount.service zfs-zed.service zfs-import-scan.service
```

#### Configure zfs-mount-generator consulting Arch wiki

```sh
mkdir /etc/zfs/zfs-list.cache
touch /etc/zfs/zfs-list.cache/nempool0
```

Note:
The nempool0 file should be populated automatically by the zed service after the first boot.
If boot fails, try again (1st boot populates, 2nd uses it).
You can manually trigger updates to this file, but only if booted into the live system (no chroot).

    `zfs-load-key@.service` is not needed, as the key is loaded by the zfs-mount-generator from `zed.service`.

## Step 13: Store zfs root pool key properly

#### Create zroot keystore dataset mounted at /etc/zfs/keys (on host machine)

See [ZFS Encryption]

```sh
sudo zfs create -o mountpoint=/zfs-keys nempool0/nemroot/keystore
sudo chmod 000 /etc/zfs/keys/nem_pool0_root.key
sudo zfs set keylocation=file:///etc/zfs/keys/nem_pool0_root.key nempool0/nemroot
sudo zfs set keylocation=file:///etc/zfs/keys/nem_pool0_root.key nempool0/nemhome
sudo zfs set org.zfsbootmenu:keysource=nempool0/nemroot/keystore nempool0/nemroot
sudo zfs set org.zfsbootmenu:keysource=nempool0/nemroot/keystore nempool0/nemhome
```

## Step 14: Configure ZFSBootMenu and mkinitcpio

```sh
mkdir -p /efi/EFI/zbm
wget https://get.zfsbootmenu.org/latest.EFI -O /efi/EFI/zbm/zfsbootmenu.EFI
```

```sh
vim /etc/zfsbootmenu/config.yaml
```

```yaml
Global:
  InitCPIO: true
  ## NOTE: The following three lines are OPTIONAL
  InitCPIOHookDirs:
    - /etc/zfsbootmenu/initcpio
    - /usr/lib/initcpio
```

###### Example file

```yaml
Global:
  InitCPIO: true
  ## NOTE: The following three lines are OPTIONAL
  InitCPIOHookDirs:
    # - /etc/zfsbootmenu/initcpio
    - /usr/lib/initcpio
  ManageImages: true
  BootMountPoint: /efi
  PreHookDir: /etc/zfsbootmenu/generate-zbm.pre.d
  postHookDir: /etc/zfsbootmenu/generate-zbm.post.d
  InitCPIOConfig: /etc/mkinitcpio.conf
Components:
  # ImageDir: /efi/EFI/zbm
  ImageDir: /boot
  Versions: 1
  Enabled: true
EFI:
  # ImageDir: /efi/EFI/zbm
  ImageDir: /boot
  Versions: false
  Enabled: true # very important lol
  SplashImage: /etc/zfsbootmenu/splash.bmp
Kernel:
  CommandLine: ro quiet loglevel=0
```

#### Set kernel parameters

```sh
sudo zgenhostid # creates /etc/hostid ## maybe add $(hostid)
# if on local machine, move it to the new zfs drive
```

### Option 1: Don't dual boot or use refind (don't do - might not work with encryption)

```sh
# sudo zfs set org.zfsbootmenu:commandline="noresume init_on_alloc=0 rw spl.spl_hostid=$(hostid)" nempool0/nemroot ## original
sudo zfs set org.zfsbootmenu:commandline="noresume init_on_alloc=0 rw nmi_watchdog=0 i915.modeset=1 spl.spl_hostid=$(hostid) initrd=/boot/initramfs-linux-lts.img" nempool0/nemroot
# sudo zfs set org.zfsbootmenu:commandline="noresume init_on_alloc=0 rw nmi_watchdog=0 spl.spl_hostid=$(hostid)" nempool0/nemroot
# sudo generate-zbm ## pretty sure Brady ran this
# mkinitcpio -P # on chroot ## Brady ran this as well
```

#### Add entry to your boot menu (assuming EFI is partition 1 of <disk>)

```sh
efibootmgr --disk <disk> --part 1 --create --label "ZFSBootMenu" --loader '\EFI\zbm\zfsbootmenu.EFI' --unicode "spl_hostid=$(hostid) zbm.timeout=3 zbm.prefer=zroot zbm.import_policy=hostid" --verbose
```

### Option 2: Use refind to boot into ZFSBootMenu (allows dual boot)

#### Add ZFSBootMenu option to refind

```txt
menuentry "Arch Linux (zfs)" {
    icon /EFI/refind/icons/arch_linux.png
    volume <efi partuuid>
    loader /EFI/zbm/zfsbootmenu.EFI
    options "zbm.prefer=nempool0/nemroot ro loglevel=0 zbm.skip"

    submenuentry "zbm menu" {
        # volume <efi partuuid> # if different than above
        loader /EFI/zbm/zfsbootmenu.EFI
        options "zbm.prefer=nempool0/nemroot ro loglevel=0 zbm.show"
}
```

## Step 15: Reboot

Consider taking a snapshot of the root dataset to have a golden image (useful to install a new system from scratch).

## Notes

To change the root encryption key, you must check the following locations:

- `sudo zfs get org.zfsbootmenu:keysource`
- `sudo zfs get keylocation`
- Verify actual path of key file on disk, e.g. `/etc/zfs/<keyname>.key`
- mkinitcpio: `/etc/mkinitcpio.conf` `FILES` array/list
- `/etc/zfs/zed/zfs-list.cache/<zpool name>` (should exist)
  - If the root dataset keylocation is incorrect inside this file, it _should_ get fixed automatically by zed.service
  - You may have to reboot twice for the update to take effect

<!-- links -->

[Arch Wiki ZFS]: https://wiki.archlinux.org/title/ZFS
[samsung 990 pro]: https://kmwoley.com/blog/zfs-ashift-values-for-samsung-990-pro-nvme-ssds/
[ZFSBootMenu]: https://docs.zfsbootmenu.org/en/v3.0.x/
[ZFS Encription]: https://docs.zfsbootmenu.org/en/v3.0.x/general/native-encryption.html
[mkinitcpio]: https://docs.zfsbootmenu.org/en/v3.0.x/general/mkinitcpio.html
