class users::andrew {
  user { 'andrew':
    ensure  => present,
    uid     => '1000',
    gid     => '1000',
    groups  => ['wheel'],
    require => Group['andrew'],
  }

  group { 'andrew':
    ensure => present,
    gid    => '1000',
  }
}
