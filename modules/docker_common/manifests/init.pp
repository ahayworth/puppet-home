class docker_common (
  String $docker_version,
  String $compose_version,
){
  class { 'docker':
    version =>  $docker_version,
  }

  class { 'docker::compose':
    ensure  => present,
    version => $compose_version,
  }
}
