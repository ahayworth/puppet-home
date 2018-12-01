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
    checksum_value => '0e965d96e8fa0a886f2c3e7234965951',
    source         => 'https://raw.github.com/ahayworth/home-assistant/ahayworth-schlage-locks/homeassistant/components/lock/zwave.py',
    require        => File[$config_dir],
  }
  file { "${config_dir}/custom_components/sensor/awair.py":
    ensure          => present,
    checksum_value  => '90cc07ae153f9b0e67c11ce807ca18cf',
    source          => 'https://raw.github.com/ahayworth/home-assistant/ahayworth-update-awair/homeassistant/components/sensor/awair.py',
    require         => File[$config_dir],
  }
  file { "${config_dir}/custom_components/google_assistant/trait.py":
    ensure         => present,
    checksum_value => 'b5bfacf237a57ec2839a1b3ce9196c29',
    source         => 'https://raw.github.com/ahayworth/home-assistant/ahayworth-google-locks/homeassistant/components/google_assistant/trait.py',
    require        => File[$config_dir],
  }
}
