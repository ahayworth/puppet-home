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
  file { '/etc/pam.d/sudo':
    content => "auth sufficient pam_fprintd.so\nauth include system-auth\naccount include system-auth\nsession include system-auth",
    require => [
      Package['libfprint-vfs0090-git'],
      Package['fprintd'],
    ],
  }
}
