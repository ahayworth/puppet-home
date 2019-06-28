class nginx_proxy::nginx (
  $proxies = {},
){
  package { 'nginx-extras':
    ensure => latest,
  }

  $managed_dirs = [
    'snippets',
    'sites-available',
    'sites-enabled',
    'conf.d',
  ]

  $managed_dirs.each |String $dir| {
    file { "/etc/nginx/${dir}":
      ensure  => directory,
      recurse => true,
      purge   => true,
      before  => Service['nginx'],
      notify  => Service['nginx'],
    }
  }

  $snippets = [
    'ssl-defaults',
  ]

  $snippets.each |String $snippet| {
    file { "/etc/nginx/snippets/${snippet}.conf":
      source => "puppet:///modules/nginx_proxy/${snippet}.conf",
      notify  => Service['nginx'],
      before  => Service['nginx'],
    }
  }

  $extra_conf = [
    'upgrade-map',
  ]

  $extra_conf.each |String $conf| {
    file { "/etc/nginx/conf.d/${conf}.conf":
      source => "puppet:///modules/nginx_proxy/${conf}.conf",
      notify  => Service['nginx'],
      before  => Service['nginx'],
    }
  }

  service { 'nginx':
    ensure  => running,
    require => Package['nginx-extras'],
  }

  file { "/etc/nginx/sites-available/acme-challenge.conf":
    ensure  => present,
    content => template("nginx_proxy/acme-challenge.conf.erb"),
    before  => Service['nginx'],
    notify  => Service['nginx'],
  }

  file { "/etc/nginx/sites-enabled/acme-challenge.conf":
    ensure => link,
    target => "/etc/nginx/sites-available/acme-challenge.conf",
    before => Service['nginx'],
    notify => Service['nginx'],
  }

  $proxies.each |String $server_name, Hash $info| {
    $filename = "upstream-proxy-${server_name}.conf"

    file { "/etc/nginx/sites-available/${filename}":
      ensure  => present,
      content => template("nginx_proxy/upstream-proxy.conf.erb"),
      before  => Service['nginx'],
      notify  => Service['nginx'],
    }

    file { "/etc/nginx/sites-enabled/${filename}":
      ensure => link,
      target => "/etc/nginx/sites-available/${filename}",
      before => Service['nginx'],
      notify => Service['nginx'],
    }
  }
}
