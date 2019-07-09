class wireguard (
  String $server_ip,
  String $server_private_key,
  Hash[String, Any] $clients,
){
  package { 'wireguard':
    ensure => latest,
  }

  $backport_packages = [
    'systemd',
    'libsystemd0',
    'libpam-systemd'
  ]

  apt::pin { 'wireguard':
    packages => $backport_packages,
    release  => 'stretch-backports',
    priority => 500,
  }

  $backport_packages.each |String $pkg| {
    package { $pkg:
      ensure  => latest,
      require => [
        Package['wireguard'],
        Apt::Pin['wireguard'],
      ]
    }
  }

  systemd::network { 'wg0.network':
    content         => template('wireguard/wg0.network.erb'),
    owner           => 'root',
    group           => 'systemd-network',
    mode            => '0640',
    restart_service => true,
  }

  systemd::network { 'wg0.netdev':
    content         => template('wireguard/wg0.netdev.erb'),
    owner           => 'root',
    group           => 'systemd-network',
    mode            => '0640',
    restart_service => true,
  }
}
