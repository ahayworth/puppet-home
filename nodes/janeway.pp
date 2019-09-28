node "janeway" {
  #include desktop
  require pacman::aur
  include pacman
  include bootloader::uefi
  include misc::packages
  include users::andrew
}
