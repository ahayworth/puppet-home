# Temporary
class misc::network::nuc {
  $network_unit_files = [
    'eno1.network',
  ]

  $network_unit_files.each |String $file| {
    systemd::network { $file:
      source          => "puppet:///modules/misc/nuc/$file",
      restart_service => true,
    }
  }
}
