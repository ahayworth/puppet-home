class zfs {
  package { 'linux-headers-amd64':
    ensure => latest
  }

  package { 'smartmontools':
    ensure => latest
  }

  $backport_packages = [
    'dkms',
    'libnvpair1linux',
    'libuutil1linux',
    'libzfs2linux',
    'libzpool2linux',
    'spl-dkms',
    'zfs-dkms',
    'zfs-test',
    'zfs-zed',
    'zfsutils-linux',
  ]

  apt::pin { 'zfs':
    packages => $backport_packages,
    release  => 'stretch-backports',
    priority => 500,
  }

  $backport_packages.each |String $pkg| {
    package { $pkg:
      ensure  => latest,
      require => [
        Apt::Pin['zfs'],
        Package['linux-headers-amd64'],
      ],
    }
  }
}
