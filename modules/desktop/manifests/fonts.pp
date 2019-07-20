class desktop::fonts(
  $packages = [],
){
  $packages.each |String $pkg| {
    package { $pkg:
      ensure => installed,
      notify => Exec['fix-fonts-path'],
    }
  }

  exec { 'fix-fonts-path':
    command      => "find /usr/share/fonts -type f -name \'* *\' -print0 | while IFS= read -rd \'\' old; do new=\${old// /}; mv \"\$old\" \$new; done",
    provider     => shell,
    refreshonly => true,
    notify       => [
      Exec['update-fc-cache'],
      Exec['update-mkfontdir'],
      Exec['update-mkfontscale'],
    ],
  }

  exec { 'update-fc-cache':
    command      => '/usr/bin/fc-cache',
    provider     => shell,
    refreshonly => true,
    notify      => Exec['gdk-pixbuf-update'],
  }

  exec { 'update-mkfontdir':
    command     => '/usr/bin/find /usr/share/fonts -type d -exec mkfontdir {} \;',
    refreshonly => true,
    notify      => Exec['gdk-pixbuf-update'],
  }

  exec { 'update-mkfontscale':
    command     => '/usr/bin/find /usr/share/fonts -type d -exec mkfontscale {} \;',
    refreshonly => true,
    notify      => Exec['gdk-pixbuf-update'],
  }

  [
    '11-lcdfilter-default.conf',
    '10-sub-pixel-rgb.conf',
    '10-hinting-slight.conf',
    '30-infinality-aliases.conf',
  ].each |String $conf| {
    file { "/etc/fonts/conf.d/$conf":
      ensure => link,
      target => "/etc/fonts/conf.avail/$conf",
      notify => Exec['gdk-pixbuf-update'],
    }
  }

  exec { 'gdk-pixbuf-update':
    command     => '/usr/bin/gdk-pixbuf-query-loaders --update-cache',
    refreshonly => true,
  }

}
