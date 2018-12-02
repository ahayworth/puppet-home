class homeassistant::config(
  String $config_dir,
  String $homeassistant_dir = lookup('homeassistant::homeassistant_dir'),
  Hash $custom_components = lookup('homeassistant::custom_components', {}),
){
  file { $config_dir:
    ensure  => directory,
    recurse => remote,
    source  => 'puppet:///modules/homeassistant/homeassistant/config',
    require => File[$homeassistant_dir],
  }

  file { "${config_dir}/custom_components":
    ensure => link,
    target => "${homeassistant_dir}/custom_components",
  }

  $custom_components.each |String $name, Hash $options| {
    homeassistant::custom_component { "${name}":
      config_dir => $homeassistant_dir,
      *          => $options,
    }
  }

  $masked_devices = lookup('homeassistant::devices::masked_devices', {})
  $masked_devices.each |String $type, Array[Hash] $devices| {
    file { "${config_dir}/device_types/${type}.yaml":
      content => template("homeassistant/${type}.yaml.erb"),
      ensure  => present,
      require => File[$config_dir],
    }
  }
}
