class homeassistant::config(
  String $config_dir,
  String $homeassistant_dir = lookup('homeassistant::homeassistant_dir'),
){
  file { $config_dir:
    ensure  => directory,
    recurse => remote,
    source  => 'puppet:///modules/homeassistant/homeassistant/config',
    require => File[$homeassistant_dir],
  }
  file { "${config_dir}/custom_components/sensor/awair.py":
    ensure         => present,
    source         => 'https://raw.github.com/ahayworth/home-assistant/awair/homeassistant/components/sensor/awair.py',
    require        => File[$config_dir],
    checksum_value => 'daf1cc0e46f9b4e68a08ce18002ce37e',
  }
  exec { "mkfifo_${config_dir}/OZW_Log.txt":
    command => "/usr/bin/mkfifo ${config_dir}/OZW_Log.txt",
    creates => "${config_dir}/OZW_Log.txt",
    require =>  Service['rsyslog'],
  }
}
