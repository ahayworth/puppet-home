class homeassistant(
  String $data_dir,
  String $homeassistant_dir,
){
  include homeassistant::config
  include homeassistant::docker
  include homeassistant::rsyslog

  file { $data_dir:
    ensure => directory,
  }

  file { $homeassistant_dir:
    ensure  => directory,
    require => File[$data_dir],
  }
}
