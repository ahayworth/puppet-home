class desktop::environment {
  $variables = lookup('desktop::environment::variables', {merge => 'hash', default_value => {}})
  $variables.each |String $key, Any $value| {
    augeas { $key:
      changes => [
        "set /files/etc/environment/$key $value",
      ]
    }
  }
}
