class plex {
  $plex_dir = '/etc/plex'
  $compose_file = "${plex_dir}/docker-compose.yaml"
  $media = '/zfs-pool-1/data'

  file { $plex_dir:
    ensure => directory,
  }

  file { "$plex_dir/config":
    ensure => directory,
  }

  file { "$plex_dir/transcode":
    ensure => directory,
  }

  file { $compose_file:
    ensure  => present,
    require => File[$plex_dir],
    content => template('plex/docker-compose.yml.erb'),
  }

  docker_compose { 'plex':
    compose_files => [$compose_file],
    ensure        => present,
    require       => [
      File[$plex_dir],
      File["$plex_dir/config"],
      File["$plex_dir/transcode"],
      File[$compose_file],
    ],
    subscribe     => File[$compose_file],
  }
}
