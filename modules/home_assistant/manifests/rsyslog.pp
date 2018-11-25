class home_assistant::rsyslog {
  file { '/var/log/docker':
    ensure => directory,
  }

  file { '/etc/rsyslog.conf':
    ensure  => present,
    source  => 'puppet:///modules/home_assistant/rsyslog/rsyslog.conf',
    notify  => Service['rsyslog'],
    require => File['/var/log/docker'],
  }

  file { '/etc/rsyslog.d/docker.conf':
    ensure => present,
    source => 'puppet:///modules/home_assistant/rsyslog/docker.conf',
    notify => Service['rsyslog'],
    require => File['/var/log/docker'],
  }

  file { '/etc/logrotate.d/docker':
    ensure => present,
    source => 'puppet:///modules/home_assistant/logrotate/docker',
  }

  service { 'rsyslog':
    ensure => running
  }
}
