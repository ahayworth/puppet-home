class home_assistant(
  String $data_dir,
  String $home_assistant_dir,
){
  include home_assistant::config
  include home_assistant::docker

  file { $data_dir:
    ensure => directory,
  }

  file { $home_assistant_dir:
    ensure  => directory,
    require => File[$data_dir],
  }
}
