class home_assistant::rsyslog {
  file { '/etc/rsyslog.conf':
    ensure => present,
    source => 'puppet:///modules/home_assistant/rsyslog/rsyslog.conf',
    notify => Service['rsyslog'],
  }

  file { '/etc/rsyslog.d/docker.conf':
    ensure => present,
    source => 'puppet:///modules/home_assistant/rsyslog/docker.conf',
    notify => Service['rsyslog'],
  }

  file { '/etc/logrotate.d/docker':
    ensure => present,
    source => 'puppet:///modules/home_assistant/logrotate/docker',
  }

  service { 'rsyslog':
    ensure => running
  }
}
