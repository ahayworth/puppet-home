define homeassistant::custom_component (
  Enum['local', 'remote'] $provider = 'remote',
  String $file,
  String $config_dir,
  Optional[String] $repo = undef,
  Optional[String] $branch = undef,
  Optional[String] $sha = undef,
  Optional[String] $checksum_value = undef,
  Optional[String] $component = undef,
){
  $config_custom = "${config_dir}/custom_components"
  if !defined(File[$config_custom]) {
    file { "${config_custom}":
      ensure  => directory,
      recurse => true,
      require => File[$config_dir],
    }
  }

  if $provider == 'remote' {
    if ($repo == undef or $checksum_value == undef or
        ($branch == undef and $sha == undef) or
        ($branch != undef and $sha != undef)) {

      fail("Need to provide repo, checksum value, and either sha OR branch!")
    }

    homeassistant::custom_component::remote { "${name}-remote":
      config_dir     => $config_custom,
      repo           => $repo,
      sha            => $sha,
      branch         => $branch,
      checksum_value => $checksum_value,
      file           => $file,
    }
  } else {
    homeassistant::custom_component::local { "${name}-local":
      config_dir => $config_custom,
      file       => $file,
      component  => $component,
    }
  }
}
