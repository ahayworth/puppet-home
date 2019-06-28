class homeassistant::docker(
  String $homeassistant_dir = lookup('homeassistant::homeassistant_dir'),
  String $config_dir = lookup('homeassistant::config::config_dir'),
  String $homeassistant_version,
  String $homeassistant_docker_repo,
  String $url,
  String $zwave_device,
  String $xbox_smartglass_version,
  Integer $homeassistant_port,
){
  $compose_file = "${homeassistant_dir}/docker-compose.yaml"
  $config_mount = "${config_dir}:/config"
  $custom_components_mount = "${homeassistant_dir}/custom_components:/config/custom_components"
  file { $compose_file:
    content =>  template('homeassistant/docker-compose.yaml.erb'),
    require =>  File[$homeassistant_dir],
  }

  docker_compose { 'homeassistant':
    compose_files => [$compose_file],
    ensure        => present,
    require       => [
      File[$compose_file],
      File[$config_dir],
    ]
  }
}
