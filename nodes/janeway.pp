node "janeway" {
  include bootloader::uefi
  include desktop
  include pacman
  include pacman::aur
  include users::andrew
  include misc::packages
}
