class misc::archlinux::desktop {
  require misc::archlinux::desktop::aur
  include misc::archlinux::desktop::gnome
  include misc::archlinux::desktop::network
  include misc::archlinux::desktop::graphics
  include misc::archlinux::desktop::firefox
  include misc::archlinux::desktop::fonts
}
