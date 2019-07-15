node "janeway" {
  include users::andrew
  include misc::packages
  include misc::archlinux::bootloader
  include misc::archlinux::desktop
  include misc::archlinux::environment
}
