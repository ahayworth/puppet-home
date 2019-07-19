class misc::archlinux::desktop {
  require misc::archlinux::desktop::aur
  include misc::archlinux::desktop::gnome
  include misc::archlinux::desktop::network
  include misc::archlinux::desktop::graphics
  include misc::archlinux::desktop::firefox
  include misc::archlinux::desktop::fonts

  package { 'cpupower':
    ensure => installed,
  }

  file { '/etc/default/cpupower':
    source => 'puppet:///modules/misc/etc/default/cpupower',
  }

  service { 'cpupower':
    ensure  => running,
    enable  => true,
    require => [
      Package['cpupower'],
      File['/etc/default/cpupower'],
    ],
  }
  service { 'lvm2-monitor':
    ensure => stopped,
    enable => false,
  }
}
