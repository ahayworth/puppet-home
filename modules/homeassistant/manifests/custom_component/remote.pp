define homeassistant::custom_component::remote(
  String $config_dir,
  String $repo,
  String $file,
  String $checksum_value,
  Optional[String] $branch = undef,
  Optional[String] $sha = undef,
) {
  $requirements = [$config_dir]
  $file_parts = $file.split('/')[2,-1]

  $fs_path = if $file_parts.length > 1 {
    $sub_path = "${config_dir}/${file_parts[0]}"
    if !defined(File[$sub_path]) {
      file { "${sub_path}":
        ensure  => directory,
        require => File[$requirements],
      }
    }
    $sub_path
  } else {
    $config_dir
  }

  $commitish = $branch ? {
    undef   => $sha,
    default => $branch,
  }

  $repo_path = [
    'https://raw.github.com',
    $repo,
    $commitish,
    $file,
  ]

  $full_fs_path = [$fs_path, $file_parts[-1]].join('/')
  $full_requirements = if $file_parts.length == 1 {
    $requirements
  } else {
    concat($requirements, "${config_dir}/${file_parts[0]}")
  }
  file { "${full_fs_path}":
    ensure         => present,
    checksum_value => $checksum_value,
    source         => $repo_path.join('/'),
    require        => File[$requirements],
  }
}
