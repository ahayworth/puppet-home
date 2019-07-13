class misc::packages(
  $packages = lookup('misc::packages', {merge => 'unique'}),
) {
  $packages.each |String $pkg| {
    package { $pkg:
      ensure => latest,
    }
  }
}
