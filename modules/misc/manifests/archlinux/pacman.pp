class misc::archlinux::pacman {
  package { 'reflector':
    ensure => installed,
  }

  file { '/etc/pacman.d/hooks':
    ensure => directory,
  }

  file { '/etc/pacman.d/hooks/mirrorupgrade.hook':
    source => 'puppet:///modules/misc/etc/pacman.d/hooks/mirrorupgrade.hook',
  }

  file { '/etc/pacman.conf':
    source => 'puppet:///modules/misc/etc/pacman.conf',
  }
}
