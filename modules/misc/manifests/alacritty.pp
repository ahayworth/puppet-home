class misc::alacritty (
  String $cargo_deb_version = '1.18.0',
  String $alacritty_version = '0.3.3',
) {
  $dependencies = [
    'cmake',
    'pkg-config',
    'libfreetype6-dev',
    'libfontconfig1-dev',
    'libxcb-xfixes0-dev',
    'python3',
  ]

  $dependencies.each |String $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }

  exec { 'cargo-deb':
    command => "/usr/bin/cargo install cargo-deb --tag v${cargo_deb_version}",
    unless  => "/usr/bin/cargo install --list cargo-deb | /usr/bin/grep 'cargo-deb v$cargo_deb_version'",
  }

  exec { 'alacritty-git':
    command => "/usr/bin/git checkout --depth 1 https://github.com/jwilm/alacritty /tmp/alacritty && cd alacritty && git fetch --tags && git checkout v$alacritty_version",
    unless  => "/usr/bin/dpkg -s alacritty | /usr/bin/grep $alacritty_version",
  }

  exec { 'install-alacritty':
    command => "/usr/bin/cargo deb --install --manifest-path /tmp/alacritty/alacritty/Cargo.toml",
    unless  => "/usr/bin/dpkg -s alacritty | /usr/bin/grep $alacritty_version",
    timeout => 0,
    require => [
      Exec['cargo-deb'],
      Exec['alacritty-git'],
    ],
    before  => File['/tmp/alacritty'],
  }

  file { '/tmp/alacritty':
    ensure  => absent,
    force   => true,
    require => Exec['install-alacritty'],
  }
}
