class desktop::misc {
  service { 'lvm2-monitor':
    ensure => stopped,
    enable => false,
  }

  service { 'fstrim.timer':
    ensure => running,
    enable => true,
  }

  package { 'libfprint-vfs0090-git':
    ensure => installed,
  }
  package { 'fprintd':
    ensure => installed,
  }
}
