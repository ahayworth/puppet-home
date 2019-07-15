class misc::archlinux::environment {
  $variables = lookup('misc::archlinux::environment::variables', {merge => 'hash', default_value => {}})
  $variables.each |String $key, Any $value| {
    augeas { $key:
      changes => [
        "set /files/etc/environment/$key $value",
      ]
    }
  }
}
