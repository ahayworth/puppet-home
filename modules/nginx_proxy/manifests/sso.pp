class nginx_proxy::sso(
  String $sso_version = '12dc0fd',

  Hash   $sso_configs,
  String $auth_port,
  String $proxy_port,

  String $allowed_emails = '',

  String $client_id,
  String $proxy_client_id,

  String $client_secret,
  String $proxy_client_secret,

  String $auth_cookie_secret,
  String $proxy_cookie_secret,

  String $auth_session_key,
) {

  $sso_dir = "/etc/sso"
  file { $sso_dir:
    ensure  => directory,
    recurse => true,
    purge   => true,
  }

  file { "${sso_dir}/upstream_configs.yml":
    content => template('nginx_proxy/upstream_configs.yml.erb'),
  }

  $compose_file = "${sso_dir}/docker-compose.yaml"
  file { $compose_file:
    content => template('nginx_proxy/docker-compose.yml.erb'),
    require => File[$sso_dir],
  }

  docker_compose { 'sso':
    compose_files => [$compose_file],
    ensure        => present,
    require       => [
      File[$compose_file],
      File[$sso_dir],
      File["${sso_dir}/upstream_configs.yml"],
    ],
  }
}
