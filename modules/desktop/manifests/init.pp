class desktop {
  include desktop::applications::firefox
  include desktop::fonts
  include desktop::gnome
  include desktop::graphics
  include desktop::network
  require desktop::cpupower
  require desktop::misc
}
