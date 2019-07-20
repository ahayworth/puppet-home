class desktop::applications::firefox(
  Enum['stable', 'beta', 'nightly'] $channel = 'stable',
){

  $package = $channel ? {
    'stable'  => 'firefox',
    'beta'    => 'firefox-beta-bin',
    'nightly' => 'firefox-nightly',
  }

  $appdir = $channel ? {
    'stable' => 'firefox',
    default  => "firefox-$channel",
  }

  package { $package:
    ensure  => installed,
  }

  file { "/opt/$appdir/defaults/pref/autoconfig.js":
    source  => 'puppet:///modules/desktop/applications/firefox/autoconfig.js',
    require => Package[$package],
  }

  file { "/opt/$appdir/firefox.cfg":
    content => template('desktop/applications/firefox/firefox.cfg.erb'),
    require => Package[$package]
  }

  file { '/usr/share/icons/hicolor/symbolic/apps/firefox-symbolic.svg':
    source => 'puppet:///modules/desktop/applications/firefox/firefox-symbolic.svg',
    notify => Exec['rebuild-icon-cache'],
  }

  [
    '16', '22', '24', '32', '48', '64', '128', '192', '256', '384',
  ].each |String $size| {
    file { "/usr/share/icons/hicolor/${size}x${size}":
      ensure => directory,
    }

    file { "/usr/share/icons/hicolor/${size}x${size}/apps":
      ensure => directory,
    }

    file { "/usr/share/icons/hicolor/${size}x${size}/apps/firefox.png":
      source => "puppet:///modules/desktop/applications/firefox/firefox-${size}x${size}.png",
      notify => Exec['rebuild-icon-cache'],
    }
  }

  # This breaks the grouping that the desktop file is trying to do, but I'd rather have icons and I can't figure out how to get the WM_CLASS right under Wayland.
  augeas { 'fix-desktop-file':
    lens    => 'Desktop.lns',
    incl    => "/usr/share/applications/$appdir.desktop",
    context => "/files/usr/share/applications/$appdir.desktop/Desktop Entry",
    changes => [
      'set StartupWMClass firefox',
      'set Icon firefox',
    ],
  }

  exec { 'rebuild-icon-cache':
    command     => '/usr/bin/gtk-update-icon-cache -f /usr/share/icons/hicolor && /usr/bin/update-desktop-database && /usr/bin/update-mime-database /usr/share/mime',
    refreshonly => true,
  }

  package { 'profile-sync-daemon':
    ensure => installed,
    notify => Exec['reload-user-systemd-psd'],
  }

  file { '/etc/sudoers.d/no-password-psd':
    source       => 'puppet:///modules/desktop/applications/firefox/no-password-psd',
    validate_cmd => '/usr/bin/visudo -c -f %',
  }

  [
    '/home/andrew/.config',
    '/home/andrew/.config/psd',
    '/home/andrew/.config/systemd',
    '/home/andrew/.config/systemd/user',
    '/home/andrew/.config/systemd/user/psd-resync.timer.d',
  ].each |String $dir| {
    file { $dir:
      ensure => directory,
      owner  => 'andrew',
      group  => 'andrew',
    }
  }

  file { '/home/andrew/.config/psd/psd.conf':
    source  => 'puppet:///modules/desktop/applications/firefox/psd.conf',
    require => File['/home/andrew/.config/psd'],
    notify  => Exec['reload-user-systemd-psd'],
    owner   => 'andrew',
    group   => 'andrew',
  }

  file { '/home/andrew/.config/systemd/user/psd-resync.timer.d/frequency.conf':
    source  => 'puppet:///modules/desktop/applications/firefox/frequency.conf',
    require => File['/home/andrew/.config/systemd/user/psd-resync.timer.d'],
    notify  => Exec['reload-user-systemd-psd'],
    owner   => 'andrew',
    group   => 'andrew',
  }

  exec { 'reload-user-systemd-psd':
    command     => '/usr/bin/systemctl --user daemon-reload && /usr/bin/systemctl --user enable psd && /usr/bin/systemctl --user start psd',
    refreshonly => true,
    user        => 'andrew',
    environment => ['HOME=/home/andrew', 'XDG_RUNTIME_DIR=/run/user/1000'],
    require     => [
      Package['profile-sync-daemon'],
      File['/home/andrew/.config/systemd/user/psd-resync.timer.d/frequency.conf'],
      File['/home/andrew/.config/psd/psd.conf'],
    ],
  }
}
