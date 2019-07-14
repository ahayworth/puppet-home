class misc::archlinux::desktop {
  require misc::archlinux::desktop::aur
  include misc::archlinux::desktop::gnome
  include misc::archlinux::desktop::network
}
