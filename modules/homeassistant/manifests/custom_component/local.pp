define homeassistant::custom_component::local(
  String $config_dir,
  String $file,
  Optional[String] $component = undef,
) {
  $requirements = [$config_dir]

  $source_base = 'puppet:///modules/homeassistant/homeassistant/custom_components'
  $dest_base = $config_dir

  if $component != undef {
    $sub_path = "${config_dir}/$component"
    if !defined(File[$sub_path]) {
      file { "${sub_path}":
        ensure  => directory,
        require => File[$requirements],
      }
    }
  }

  $full_dest = if $component != undef {
    "${dest_base}/${component}/${file}"
  } else {
    "${dest_base}/${file}"
  }

  $full_source = if $component != undef {
    "${source_base}/${component}/${file}"
  } else {
    "${source_base}/${file}"
  }

  $full_requirements = if $component == undef {
    concat($requirements, "${config_dir}/${component}")
  } else {
    $requirements
  }

  file { "$full_dest":
    ensure  => present,
    source  => $full_source,
    require => File[$full_requirements],
  }
}
