class desktop::network {
  $packages = [
    'networkmanager',
    'wireguard-tools',
    'wireguard-arch',
  ]
  $packages.each |String $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }

  file { '/etc/NetworkManager/NetworkManager.conf':
    source => 'puppet:///modules/desktop/NetworkManager.conf',
    notify => Service['NetworkManager'],
  }

  service { 'NetworkManager':
    enable  => true,
    require => [
      Package['gnome'],
      File['/etc/NetworkManager/NetworkManager.conf'],
    ],
  }
}
