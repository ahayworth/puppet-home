#!/bin/bash

set -e

DISK='/dev/nvme0n1'

if [[ "$1" != "--stage-two" ]]; then
  systemctl start iwd
  iwctl station wlan0 connect skynet
  dhcpcd
  timedatectl set-ntp true

  sfdisk $DISK <<EOF
label: gpt
label-id: BE841A3A-3393-2E4D-AAC3-87A61B03DCC7
device: /dev/nvme0n1
unit: sectors
first-lba: 2048
last-lba: 976773134

/dev/nvme0n1p1 : start=        2048, size=     1048576, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B, uuid=8420A67B-A004-6745-B881-1E0FA8C7791D
/dev/nvme0n1p2 : start=     1050624, size=    41943040, type=0657FD6D-A4AB-43C4-84E5-0933C84B4F4F, uuid=0B770CFB-15C2-6346-A693-8E0212213B04
/dev/nvme0n1p3 : start=    42993664, size=   933779471, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=630822BE-BA9C-0A49-A7DF-B007CEF1CD6F
EOF

  mkfs.fat -F32 -n efi ${DISK}p1
  mkswap -L swap ${DISK}p2
  mkfs.btrfs -f -L root ${DISK}p3

  swapon ${DISK}p2
  mount -o noatime,compress=zstd,autodefrag ${DISK}p3 /mnt
  mkdir /mnt/boot
  mount ${DISK}p1 /mnt/boot

  grep -A1 'United States' /etc/pacman.d/mirrorlist | egrep -v '(\-\-|United States)' > /tmp/foo
  mv /tmp/foo /etc/pacman.d/mirrorlist
  pacstrap /mnt base base-devel iwd btrfs-progs terminus-font
  genfstab -L /mnt >> /mnt/etc/fstab

  cp "$0" /mnt/
  arch-chroot /mnt /$(basename "$0") --stage-two
else

  ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
  setfont ter-v22n
  hwclock --systohc
  echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
  echo 'LANG=en_US.UTF-8' > /etc/locale.conf
  locale-gen
  echo 'janeway' > /etc/hostname
  echo '127.0.0.1 janeway.boyfriend.network janeway' > /etc/hosts
  echo '::1       janeway.boyfriend.network janeway' >>/etc/hosts
  echo '127.0.1.1 janeway.boyfriend.network janeway' >>/etc/hosts
  echo 'KEYMAP=us' > /etc/vconsole.conf
  echo 'FONT=ter-v22n' >> /etc/vconsole.conf
  echo 'MODULES=(i915)' > /etc/mkinitcpio.conf
  echo 'BINARIES=()' >> /etc/mkinitcpio.conf
  echo 'FILES=()' >> /etc/mkinitcpio.conf
  echo 'HOOKS=(systemd autodetect block filesystems modconf sd-vconsole keyboard)' >> /etc/mkinitcpio.conf
  echo 'COMPRESSION="cat"' >> /etc/mkinitcpio.conf
  mkinitcpio -p linux
  pacman -Sy efibootmgr git openssh python-pip tmux vim lsb-release sudo
  pacman -Rnu vi
  ln -sf /usr/bin/vim /usr/bin/vi
  efibootmgr --disk ${DISK} --part 1 --create \
    --label 'Arch Linux' --loader /vmlinuz-linux \
    --unicode 'root=/dev/nvme0n1p3 rw quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log_priority=3 i915.fastboot=1 vga=current initrd=\initramfs-linux.img' \
    --verbose
  systemctl enable iwd
  useradd -m -u 1000 andrew
  usermod -G wheel -a andrew
  echo 'set root password'
  passwd
  echo 'set user password'
  passwd andrew
  echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
fi

echo "finished, I think"
