class nginx_proxy::sso(
  String $version = '1.2.0',
  String $allowed_emails = '',
  String $client_id,
  String $proxy_client_id,
  String $client_secret,
  String $proxy_client_secret,
  String $auth_auth_code_secret,
  String $auth_cookie_secret,
  String $proxy_auth_code_secret,
  String $proxy_cookie_secret,
  Hash   $sso_configs,
  String $auth_port,
  String $proxy_port,
) {

  file { '/etc/sso':
    ensure  => directory,
    recurse => true,
    purge   => true,
  }

  file { "/etc/sso/sso-${version}.tar.gz":
    ensure  => present,
    require => Archive["/etc/sso/sso-${version}.tar.gz"],
  }

  file { '/etc/sso/upstream_configs.yml':
    content => template('nginx_proxy/upstream_configs.yml.erb'),
    before  => [
      Service['sso-proxy'],
      Service['sso-auth'],
    ],
    notify  => [
      Service['sso-proxy'],
      Service['sso-auth'],
    ],
  }

  archive { "/etc/sso/sso-${version}.tar.gz":
    ensure       => present,
    source       => "https://github.com/buzzfeed/sso/releases/download/v${version}/sso-${version}-linux-amd64-go1.12.1.tar.gz",
    extract      => true,
    extract_path => '/usr/bin',
    cleanup      => false,
    notify       => [
      Exec['chmod sso'],
      Service['sso-proxy'],
      Service['sso-auth'],
    ],
    require      => File['/etc/sso'],
  }

  exec { 'chmod sso':
    command     => '/bin/chmod a+x /usr/bin/sso-*',
    refreshonly => true,
  }

  $services = [
    'sso-proxy',
    'sso-auth',
  ]

  $services.each |String $service| {
    file { "/etc/systemd/system/${service}.service":
      content => template("nginx_proxy/${service}.service.erb"),
      notify  => Service["${service}"],
    }

    service { "${service}":
      ensure  => running,
      require => [
        File["/etc/systemd/system/${service}.service"],
        Archive["/etc/sso/sso-${version}.tar.gz"],
      ],
    }
  }
}
