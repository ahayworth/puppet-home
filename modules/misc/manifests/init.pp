# Oh, I hate myself already for doing this.
class misc {
  include apt

  $misc_packages = [
    'tmux',
    'htop',
    'mosh',
  ]
  $misc_packages.each |String $pkg| {
    package { $pkg:
      ensure => latest,
    }
  }

  class { 'nodejs':
    repo_url_suffix    => '12.x',
    repo_pin           => '500',
    npm_package_ensure => 'present',
  }
}
