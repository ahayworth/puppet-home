class pacman::aur {
  file { '/usr/bin/yaourt':
    source => 'puppet:///modules/pacman/yay-wrapper',
    mode   => '0755',
  }

  # this is largely to make puppet work well
  file { '/etc/sudoers.d/no-password-aur':
    source       => 'puppet:///modules/pacman/no-password-aur',
    validate_cmd => '/usr/bin/visudo -c -f %',
  }
}
