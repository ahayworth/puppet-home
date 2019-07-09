class misc::laptop {
  # https://github.com/Mayccoll/Gogh/issues/63
  package { 'uuid-runtime':
    ensure => installed,
  }

  package { 'fonts-inconsolata':
    ensure => installed,
  }

  package { 'fonts-firacode':
    ensure => installed,
  }
}
