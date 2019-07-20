class bootloader::uefi (
  String $efi_disk,
  Integer $efi_partition,
  String $root,
  String $label,
  String $loader,
  String $kernel_opts,
  String $initrd,
  String $ucode_initrd = undef,
  String $ucode_package = undef,
){

  if $ucode_package != undef {
    package { $ucode_package:
      ensure => installed,
      before => Exec['efibootmgr-delete'],
    }
  }

  $kernel_cmdline = "root=$root $kernel_opts"

  $boot_re = $ucode_initrd ? {
    undef => ".+$label.+$loader)$kernel_cmdline.+$initrd",
    default => ".+$label.+$loader)$kernel_cmdline.+$ucode_initrd.+$initrd"
  }

  exec { 'efibootmgr-delete':
    command => "/usr/bin/efibootmgr -b 0000 --delete-bootnum || /bin/true",
    unless  => "/usr/bin/efibootmgr --unicode -v | /usr/bin/grep Boot0000 | /usr/bin/egrep '$boot_re'",
    notify  => Exec['efibootmgr-install'],
  }

  $initrd_merged = $ucode_initrd ? {
    undef => "initrd=\\${initrd}",
    default => "initrd=\\${ucode_initrd} initrd=\\${initrd}",
  }
  exec { 'efibootmgr-install':
    command     => "/usr/bin/efibootmgr --disk $efi_disk --part $efi_partition --create --label '$label' --loader /$loader --unicode '$kernel_cmdline $initrd_merged'",
    require     => Exec['efibootmgr-delete'],
    refreshonly => true,
  }
}
