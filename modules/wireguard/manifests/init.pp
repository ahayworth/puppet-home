class wireguard (
  String $server_ip,
  String $server_private_key,
  Hash[String, Any] $clients,
){
  package { 'wireguard':
    ensure => latest,
  }

  file { '/etc/wireguard/wg0.conf':
    ensure  => present,
    content => template('wireguard/wg0.conf.erb'),
    mode    => '0600',
    notify  => [
      Service['wg-quick@wg0.service'],
      Exec['reload-systemd'],
    ],
    require => Package['wireguard'],
  }

  service { 'wg-quick@wg0.service':
    ensure  => running,
    enable  => true,
    require => [
      File['/etc/wireguard/wg0.conf'],
      File['/etc/sysctl.d/98-ip_forward.conf'],
      Exec['reload-sysctl'],
      Exec['reload-systemd'],
    ],
  }

  file { '/etc/sysctl.d/98-ip_forward.conf':
    ensure  => present,
    content => 'net.ipv4.ip_forward=1',
    notify  => Exec['reload-sysctl'],
  }

  exec { 'reload-sysctl':
    command     => '/sbin/sysctl -p',
    refreshonly => true,
  }

  exec { 'reload-systemd':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }
}
