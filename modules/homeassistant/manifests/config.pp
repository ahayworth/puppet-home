class homeassistant::config(
  String $config_dir,
  String $homeassistant_dir = lookup('homeassistant::homeassistant_dir'),
  String $xbox_json,
  Hash $custom_components = lookup('homeassistant::custom_components', {}),
  Hash $remote_serial_connections = lookup('homeassistant::remote_serial_connections', {}),
  Hash $secrets,
){
  file { $config_dir:
    ensure  => directory,
    recurse => remote,
    source  => 'puppet:///modules/homeassistant/homeassistant/config',
    ignore  => 'custom_components',
    require => File[$homeassistant_dir],
  }

  file { "${config_dir}/custom_components":
    ensure => link,
    target => "${homeassistant_dir}/custom_components",
  }

  file { "${config_dir}/xbox_tokens":
    ensure  => present,
    content => $xbox_json,
  }

  file { "${config_dir}/secrets.yaml":
    ensure  => present,
    content => to_yaml($secrets),
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

  $remote_serial_connections.each |String $name, Hash $options| {
    homeassistant::remote_serial { "$name":
      * => $options
    }
  }
}
