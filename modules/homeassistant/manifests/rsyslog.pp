class homeassistant::rsyslog {
  file { '/var/log/docker':
    ensure => directory,
  }

  file { '/etc/rsyslog.conf':
    ensure  => present,
    source  => 'puppet:///modules/homeassistant/rsyslog/rsyslog.conf',
    notify  => Service['rsyslog'],
    require => File['/var/log/docker'],
  }

  file { '/etc/rsyslog.d/docker.conf':
    ensure => present,
    source => 'puppet:///modules/homeassistant/rsyslog/docker.conf',
    notify => Service['rsyslog'],
    require => File['/var/log/docker'],
  }

  file { '/etc/logrotate.d/docker':
    ensure => present,
    source => 'puppet:///modules/homeassistant/logrotate/docker',
  }

  service { 'rsyslog':
    ensure => running
  }
}
