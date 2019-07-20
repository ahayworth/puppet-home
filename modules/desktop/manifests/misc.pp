class desktop::misc {
  service { 'lvm2-monitor':
    ensure => stopped,
    enable => false,
  }
}
