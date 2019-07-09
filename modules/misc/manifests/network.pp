# Temporary
class misc::network {
  service { 'systemd-networkd':
    ensure  => running,
    enable  => true,
    require => [
      Exec['reload-systemd'],
      File['/etc/systemd/network/bond1.netdev'],
      File['/etc/systemd/network/bond1.network'],
      File['/etc/systemd/network/vlan10.network'],
      File['/etc/systemd/network/vlan10.netdev'],
      File['/etc/systemd/network/enp1s0.network'],
      File['/etc/systemd/network/enp5s0.network'],
      Package['ifenslave'],
    ],
  }

  service { 'systemd-resolved':
    ensure  => running,
    enable  => true,
    require => [
      Service['systemd-networkd'],
    ],
  }

  file { '/etc/systemd/network/bond1.netdev':
    ensure => present,
    source => 'puppet:///modules/misc/bond1.netdev',
    notify => [
      Service['systemd-networkd'],
      Exec['reload-systemd'],
    ]
  }

  file { '/etc/systemd/network/bond1.network':
    ensure => present,
    source => 'puppet:///modules/misc/bond1.network',
    notify => [
      Service['systemd-networkd'],
      Exec['reload-systemd'],
    ]
  }

  file { '/etc/systemd/network/vlan10.network':
    ensure => present,
    source => 'puppet:///modules/misc/vlan10.network',
    notify => [
      Service['systemd-networkd'],
      Exec['reload-systemd'],
    ]
  }

  file { '/etc/systemd/network/vlan10.netdev':
    ensure => present,
    source => 'puppet:///modules/misc/vlan10.netdev',
    notify => [
      Service['systemd-networkd'],
      Exec['reload-systemd'],
    ]
  }

  file { '/etc/systemd/network/enp1s0.network':
    ensure => present,
    source => 'puppet:///modules/misc/enp1s0.network',
    notify => [
      Service['systemd-networkd'],
      Exec['reload-systemd'],
    ]
  }

  file { '/etc/systemd/network/enp5s0.network':
    ensure => present,
    source => 'puppet:///modules/misc/enp5s0.network',
    notify => [
      Service['systemd-networkd'],
      Exec['reload-systemd'],
    ]
  }

  package { 'ifenslave':
    ensure => latest,
  }

  file { '/etc/resolv.conf':
    ensure => link,
    target => '/run/systemd/resolve/resolv.conf',
  }
}
