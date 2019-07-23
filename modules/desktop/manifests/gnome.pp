class desktop::gnome(
  Hash $gconf_settings = {},
){
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
    enable  => true,
    require => Package['gdm'],
  }

  $gconf_settings.each |String $schema, Hash $kv| {
    $kv.each |String $key, Any $value| {
      exec { "set-$schema-$key-$value":
        command     => "/usr/bin/gsettings set $schema $key $value",
        unless      => "/usr/bin/gsettings get $schema $key | /usr/bin/grep -q $value",
        user        => 'andrew',
        environment => ['HOME=/home/andrew', 'XDG_RUNTIME_DIR=/run/user/1000'],
      }
    }
  }
}
