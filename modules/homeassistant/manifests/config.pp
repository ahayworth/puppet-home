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
  file { "${config_dir}/custom_components/lock/zwave.py":
    ensure         => present,
    #checksum_value => 'daeee9db12bc830c68086e58cdd2f0f0',
    source         => 'https://raw.github.com/ahayworth/home-assistant/ahayworth-schlage-locks/homeassistant/components/lock/zwave.py',
    require        => File[$config_dir],
  }
}
