class desktop::cpupower {
  package { 'cpupower':
    ensure => installed,
  }

  file { '/etc/default/cpupower':
    source => 'puppet:///modules/desktop/cpupower',
  }

  service { 'cpupower':
    ensure  => running,
    enable  => true,
    require => [
      Package['cpupower'],
      File['/etc/default/cpupower'],
    ],
  }

  package { 'thermald':
    ensure => installed,
  }

  service { 'thermald':
    ensure  => running,
    enable  => true,
    require => Package['thermald'],
  }
}
