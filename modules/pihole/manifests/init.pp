class pihole(
  String $password,
  Hash $ipam = lookup('ipam::networks'),
){
  $pihole_dir = '/etc/pihole'
  $dnsmasq_dir = '/etc/dnsmasq.d'
  $compose_file = "${pihole_dir}/docker-compose.yaml"

  file { $pihole_dir:
    ensure => directory,
  }

  file { $dnsmasq_dir:
    ensure => directory,
  }

  file { "$dnsmasq_dir/99-custom.conf":
    content => template('pihole/99-custom.conf.erb'),
    require => File[$dnsmasq_dir],
  }

  file { $compose_file:
    ensure  => present,
    require => File[$pihole_dir],
    content => template('pihole/docker-compose.yml.erb'),
  }

  docker_compose { 'pihole':
    compose_files => [$compose_file],
    ensure        => present,
    require       => [
      File[$compose_file],
      File[$pihole_dir],
      File[$dnsmasq_dir],
      File["$dnsmasq_dir/99-custom.conf"],
    ],
    subscribe     => File["$dnsmasq_dir/99-custom.conf"],
  }
}
