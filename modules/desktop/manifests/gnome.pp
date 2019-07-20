class desktop::gnome {
  $packages = [
    'gnome',
    'gnome-tweaks',
    'gnome-power-manager',
    'gdm',
    'xorg-server-xwayland',
  ]

  $packages.each |String $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }

  file { '/usr/share/applications/org.gnome.Epiphany.desktop':
    ensure  => absent,
    require => Package['gnome'],
    notify  => Exec['rebuild-cache-to-remove-epiphany'],
  }

  exec { 'rebuild-cache-to-remove-epiphany':
    command     => '/usr/bin/gtk-update-icon-cache -f /usr/share/icons/hicolor && /usr/bin/update-desktop-database && /usr/bin/update-mime-database /usr/share/mime',
    refreshonly => true,
  }

  service { 'gdm':
    ensure  => running,
    enable  => true,
    require => Package['gdm'],
  }
}
