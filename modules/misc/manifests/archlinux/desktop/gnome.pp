class misc::archlinux::desktop::gnome {
  $packages = [
    'gnome',
    'gnome-tweaks',
    'gdm',
    'xorg-server-xwayland',
  ]

  $packages.each |String $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }

  service { 'gdm':
    ensure  => running,
    enable  => true,
    require => Package['gdm'],
  }
}
