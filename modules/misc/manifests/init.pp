# Oh, I hate myself already for doing this.
class misc {
  include apt
  package { 'tmux':
    ensure => latest,
  }
}
