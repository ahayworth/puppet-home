class docker_misc {
  $compose_file = "/etc/docker-compose-airconnect.yaml"

  file { $compose_file:
    source => 'puppet:///modules/docker_misc/airconnect.yaml',
  }

  docker_compose { 'airconnect':
    compose_files => [$compose_file],
    ensure        => present,
    require       => [
      File[$compose_file],
    ],
  }
}
