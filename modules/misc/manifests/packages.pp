class misc::packages {
  $installed = lookup('misc::packages::installed', {merge => 'unique', default_value => []})
  $removed = lookup('misc::packages::removed', {merge => 'unique', default_value => []})
  $installed.each |String $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }

  $removed.each |String $pkg| {
    package { $pkg:
      ensure => absent,
    }
  }
}
