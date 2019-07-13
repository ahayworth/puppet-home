class misc::packages(
  $installed = lookup('misc::packages::installed', {merge => 'unique'}),
  $purged = lookup('misc::packages::purged', {merge => 'unique'}),
) {
  $installed.each |String $pkg| {
    package { $pkg:
      ensure => latest,
    }
  }

  $purged.each |String $pkg| {
    package { $pkg:
      ensure => purged,
    }
  }
}
