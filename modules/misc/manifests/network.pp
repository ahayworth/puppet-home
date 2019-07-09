# Temporary
class misc::network {
  $network_unit_files = [
    'bond1.netdev',
    'bond1.network',
    'vlan10.netdev',
    'vlan10.network',
    'enp1s0.network',
    'enp5s0.network',
  ]

  $network_unit_files.each |String $file| {
    systemd::network { $file:
      source          => "puppet:///modules/misc/$file",
      restart_service => true,
      require         => [
        Package['ifenslave'],
      ]
    }
  }

  package { 'ifenslave':
    ensure => latest,
  }
}
