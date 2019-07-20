class pacman {
  package { 'reflector':
    ensure => installed,
  }

  file { '/etc/pacman.d/hooks':
    ensure => directory,
  }

  file { '/etc/pacman.d/hooks/mirrorupgrade.hook':
    source => 'puppet:///modules/pacman/mirrorupgrade.hook',
  }

  file { '/etc/pacman.conf':
    source => 'puppet:///modules/pacman/pacman.conf',
  }
}
