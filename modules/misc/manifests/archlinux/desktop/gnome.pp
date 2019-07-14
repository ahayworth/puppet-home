class misc::archlinux::desktop::gnome {
  $packages = [
    'gnome',
    'gdm',
    'xorg-server-xwayland',
  ]

  $packages.each |String $pkg| {
    package { $pkg:
      ensure => latest,
    }
  }

  service { 'gdm':
    ensure  => running,
    enable  => true,
    require => Package['gdm'],
  }
}
