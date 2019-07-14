class misc::archlinux::desktop::aur {
  file { '/usr/bin/yaourt':
    source => 'puppet:///modules/misc/usr/bin/yay-wrapper',
    mode   => '0755',
  }

  # this is largely to make puppet work well
  file { '/etc/sudoers.d/no-password-aur':
    source       => 'puppet:///modules/misc/etc/sudoers.d/no-password-aur',
    validate_cmd => '/usr/bin/visudo -c -f %',
  }
}
