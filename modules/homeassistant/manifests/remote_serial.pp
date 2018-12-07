define homeassistant::remote_serial (
  String $local_socket,
  String $remote_addr,
){
  file { "/etc/systemd/system/socat-$name.service":
    content => template('homeassistant/socat.service.erb'),
    notify  => [
      Exec['systemd-daemon-reload'],
      Exec["systemd-enable-socat-$name.service"],
      Service["socat-$name"],
    ],
  }

  # TODO - move this somewhere else, yuck
  if !defined(Exec['systemd-daemon-reload']) {
    exec { "systemd-daemon-reload":
      refreshonly => true,
      command     => '/bin/systemctl daemon-reload',
    }
  }

  # also ew
  if !defined(Package['socat']) {
    package { 'socat':
      ensure => latest,
    }
  }

  exec { "systemd-enable-socat-$name.service":
    refreshonly => true,
    command     => "/bin/systemctl enable socat-$name.service",
  }

  service { "socat-$name":
    ensure  => running,
    require  => File["/etc/systemd/system/socat-$name.service"],
  }
}
