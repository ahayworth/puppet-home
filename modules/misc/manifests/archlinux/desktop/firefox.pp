class misc::archlinux::desktop::firefox {
  package { 'firefox-beta-bin':
    ensure => installed,
  }

  file { '/opt/firefox-beta/defaults/pref/autoconfig.js':
    source  => 'puppet:///modules/misc/opt/firefox-beta/defaults/pref/autoconfig.js',
    require => Package['firefox-beta-bin'],
  }

  file { '/opt/firefox-beta/firefox.cfg':
    content => template('misc/opt/firefox-beta/firefox.cfg.erb'),
    require => Package['firefox-beta-bin']
  }

  file { '/usr/share/icons/hicolor/symbolic/apps/firefox-symbolic.svg':
    source => 'puppet:///modules/misc/usr/share/icons/hicolor/symbolic/apps/firefox-symbolic.svg',
    notify => Exec['rebuild-icon-cache'],
  }

  file { '/usr/share/icons/hicolor/symbolic/apps/firefox-beta-symbolic.svg':
    source => 'puppet:///modules/misc/usr/share/icons/hicolor/symbolic/apps/firefox-symbolic.svg',
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
      source => "puppet:///modules/misc/usr/share/icons/hicolor/${size}x${size}/apps/firefox.png",
      notify => Exec['rebuild-icon-cache'],
    }

    file { "/usr/share/icons/hicolor/${size}x${size}/apps/firefox-beta.png":
      source => "puppet:///modules/misc/usr/share/icons/hicolor/${size}x${size}/apps/firefox.png",
      notify => Exec['rebuild-icon-cache'],
    }
  }

  # This breaks the grouping that the desktop file is trying to do, but I'd rather have icons and I can't figure out how to get the WM_CLASS right under Wayland.
  augeas { 'fix-desktop-file':
    lens    => 'Desktop.lns',
    incl    => '/usr/share/applications/firefox-beta-bin.desktop',
    context => '/files/usr/share/applications/firefox-beta-bin.desktop/Desktop Entry',
    changes => [
      'set StartupWMClass firefox',
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
    source       => 'puppet:///modules/misc/etc/sudoers.d/no-password-psd',
    validate_cmd => '/usr/bin/visudo -c -f %',
  }

  [
    '/home/andrew/.config/psd',
    '/home/andrew/.config/systemd',
    '/home/andrew/.config/systemd/user',
    '/home/andrew/.config/systemd/user/default.target.wants/',
    '/home/andrew/.config/systemd/user/psd-resync.timer.d',
  ].each |String $dir| {
    file { $dir:
      ensure => directory,
      owner  => 'andrew',
      group  => 'andrew',
    }
  }

  file { '/home/andrew/.config/psd/psd.conf':
    source  => 'puppet:///modules/misc/home/andrew/.config/psd/psd.conf',
    require => File['/home/andrew/.config/psd'],
    notify  => Exec['reload-user-systemd-psd'],
    owner   => 'andrew',
    group   => 'andrew',
  }

  file { '/home/andrew/.config/systemd/user/psd-resync.timer.d/frequency.conf':
    source  => 'puppet:///modules/misc/home/andrew/.config/systemd/user/psd-resync.timer.d/frequency.conf',
    require => File['/home/andrew/.config/systemd/user/psd-resync.timer.d'],
    notify  => Exec['reload-user-systemd-psd'],
    owner   => 'andrew',
    group   => 'andrew',
  }

  file { '/home/andrew/.config/systemd/user/default.target.wants/psd.service':
    ensure  => link,
    target  => '/usr/lib/systemd/user/psd.service',
    require => [
      Package['profile-sync-daemon'],
      File['/home/andrew/.config/systemd/user/default.target.wants/'],
    ],
    notify  => Exec['reload-user-systemd-psd'],
    owner   => 'andrew',
    group   => 'andrew',
  }

  exec { 'reload-user-systemd-psd':
    command     => '/usr/bin/systemctl --user daemon-reload && /usr/bin/systemctl --user start psd',
    refreshonly => true,
    user        => 'andrew',
    environment => ['HOME=/home/andrew', 'XDG_RUNTIME_DIR=/run/user/1000'],
    require     => [
      Package['profile-sync-daemon'],
      File['/home/andrew/.config/systemd/user/default.target.wants/psd.service'],
      File['/home/andrew/.config/systemd/user/psd-resync.timer.d/frequency.conf'],
      File['/home/andrew/.config/psd/psd.conf'],
    ],
  }
}
