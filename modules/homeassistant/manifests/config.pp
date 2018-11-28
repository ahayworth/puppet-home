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
  file { "${config_dir}/custom_components/lock/zwave.py":
    ensure         => present,
    #checksum_value => 'daeee9db12bc830c68086e58cdd2f0f0',
    source         => 'https://raw.github.com/ahayworth/home-assistant/ahayworth-schlage-locks/homeassistant/components/lock/zwave.py',
    require        => File[$config_dir],
  }
  file { "${config_dir}/custom_components/media_player/onkyo.py":
    ensure         => present,
    #checksum_value => 'daeee9db12bc830c68086e58cdd2f0f0',
    source         => 'https://raw.github.com/ahayworth/home-assistant/dev/homeassistant/components/media_player/onkyo.py',
    require        => File[$config_dir],
  }
}
