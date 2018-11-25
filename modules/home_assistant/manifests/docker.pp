class home_assistant::docker(
  String $compose_version,
  String $home_assistant_dir = lookup('home_assistant::home_assistant_dir'),
  String $config_dir = lookup('home_assistant::config::config_dir'),
  String $home_assistant_version,
  String $home_assistant_docker_repo,
  String $url,
  String $zwave_device,
  String $xbox_smartglass_version,
){
  include 'docker'
  class { 'docker::compose':
    ensure  => present,
    version => $compose_version,
  }

  $compose_file = "${home_assistant_dir}/docker-compose.yaml"
  $config_mount = "${config_dir}:/config"
  file { $compose_file:
    content =>  template('home_assistant/docker-compose.yaml.erb'),
    require =>  File[$home_assistant_dir],
  }

  docker_compose { 'home_assistant':
    compose_files => [$compose_file],
    ensure        => present,
    require       => [
      File[$compose_file],
      File[$config_dir],
    ]
  }
}
