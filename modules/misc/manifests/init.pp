# Oh, I hate myself already for doing this.
class misc(
  Boolean $install_nodejs = true,
){
  include apt

  $misc_packages = [
    'tmux',
    'htop',
    'mosh',
    'tcpdump',
    'dnsutils',
  ]
  $misc_packages.each |String $pkg| {
    package { $pkg:
      ensure => latest,
    }
  }

  if $install_nodejs {
    class { 'nodejs':
      repo_url_suffix    => '12.x',
      repo_pin           => '500',
      npm_package_ensure => 'present',
    }
  }
}
