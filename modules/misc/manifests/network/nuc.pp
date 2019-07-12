# Temporary
class misc::network::nuc {
  $network_unit_files = [
    'vlan10.netdev',
    'vlan10.network',
    'eno1.network',
  ]

  $network_unit_files.each |String $file| {
    systemd::network { $file:
      source          => "puppet:///modules/misc/nuc/$file",
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