class docker_common (
  String $docker_version = "5:18.09.3~3-0~debian-${facts['os']['distro']['codename']}",
  String $compose_version = '1.23.2',
){
  class { 'docker':
    version =>  $docker_version,
  }

  class { 'docker::compose':
    ensure  => present,
    version => $compose_version,
  }
}
