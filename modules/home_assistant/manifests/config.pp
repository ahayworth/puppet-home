class home_assistant::config(
  String $config_dir,
  String $home_assistant_dir = lookup('home_assistant::home_assistant_dir')
){
  file { $config_dir:
    ensure  => directory,
    recurse => remote,
    source  => 'puppet:///modules/home_assistant/home_assistant/config',
    require => File[$home_assistant_dir],
  }
  file { "${config_dir}/custom_components/sensor":
    ensure  => directory,
    require => File[$config_dir],
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
