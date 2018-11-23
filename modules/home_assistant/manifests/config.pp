class home_assistant::config(
  String $config_dir,
  String $home_assistant_dir = lookup('home_assistant::home_assistant_dir')
){
  file { $config_dir:
    ensure  => directory,
    recurse => remote,
    source  => 'puppet:///modules/home_assistant/home_assistant/config',
    require => File[$home_assistant_dir],
  }
}
