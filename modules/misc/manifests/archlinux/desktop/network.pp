class misc::archlinux::desktop::network {
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
    source => 'puppet:///modules/misc/etc/NetworkManager/NetworkManager.conf',
    notify => Service['NetworkManager'],
  }

  service { 'NetworkManager':
    ensure  => running,
    enable  => true,
    require => [
      Package['gnome'],
      File['/etc/NetworkManager/NetworkManager.conf'],
    ],
  }
}
