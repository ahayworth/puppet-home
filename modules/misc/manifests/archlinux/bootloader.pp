class misc::archlinux::bootloader(
  String $efi_disk = "/dev/nvme0n1",
  String $efi_partition = "1",
  String $root = "root=${efi_disk}p3",
  String $label = "Arch Linux",
  String $loader = "vmlinuz-linux",
  String $kernel_opts = "quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log_priority=3 i915.fastboot=1 vga=current",
  String $initrd = 'initramfs-linux.img',
  String $ucode_initrd = 'intel-ucode.img'
){
  package { 'intel-ucode':
    ensure => latest,
  }

  $kernel_cmdline = "$root rw quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log_priority=3 i915.fastboot=1 vga=current"
  $boot_re = ".+$label.+$loader)$kernel_cmdline.+$ucode_initrd.+$initrd"

  exec { 'efibootmgr-delete':
    command => "/usr/bin/efibootmgr -b 0000 --delete-bootnum || /bin/true",
    unless  => "/usr/bin/efibootmgr --unicode -v | /usr/bin/grep Boot0000 | /usr/bin/egrep '$boot_re'",
    require => Package['intel-ucode'],
    notify  => Exec['efibootmgr-install'],
  }

  $initrd_merged = "initrd=\\${ucode_initrd} initrd=\\${initrd}"
  exec { 'efibootmgr-install':
    command     => "/usr/bin/efibootmgr --disk $efi_disk --part $efi_partition --create --label '$label' --loader /$loader --unicode '$kernel_cmdline $initrd_merged'",
    require     => Exec['efibootmgr-delete'],
    refreshonly => true,
  }
}
