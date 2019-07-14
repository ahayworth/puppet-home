class misc::firmware(
  $packages = []
){
  $packages.each |String $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }
}
