class pacman::aur {
  package { 'go':
    ensure => installed,
  }

  exec { 'needs_yay':
    command => '/bin/true',
    unless  => '/usr/bin/stat /usr/bin/yay',
    notify  => Exec['vcsrepo_yay'],
  }

  exec { 'vcsrepo_yay':
    refreshonly => true,
    user        => 'andrew',
    command     => '/usr/bin/git clone https://aur.archlinux.org/yay.git /tmp/yay',
    notify      => Exec['makepkg_yay'],
  }

  exec { 'makepkg_yay':
    command     => '/usr/bin/sudo -u andrew /bin/bash -c "cd /tmp/yay && makepkg -f"',
    require     => [
      Package['go'],
    ],
    refreshonly => true,
    notify      => Exec['install_yay'],
  }

  exec { 'install_yay':
    command     => '/usr/bin/pacman -U --noconfirm /tmp/yay/yay*.pkg.tar.xz',
    notify      => Exec['cleanup_yay'],
    refreshonly => true,
  }

  exec { 'cleanup_yay':
    command     => '/bin/rm -rf /tmp/yay',
    refreshonly => true,
  }

  file { '/usr/bin/yaourt':
    source => 'puppet:///modules/pacman/yay-wrapper',
    mode   => '0755',
  }

  file { '/etc/sudoers.d/no-password-aur':
    source       => 'puppet:///modules/pacman/no-password-aur',
    validate_cmd => '/usr/bin/visudo -c -f %',
  }
}
