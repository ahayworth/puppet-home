class misc::packages {
  $installed = lookup('misc::packages::installed', {merge => 'unique'})
  $removed = lookup('misc::packages::removed', {merge => 'unique'})
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
