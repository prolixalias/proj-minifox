# configure puppet device

#
class minifox::policy::infrastructure::network::device_manager {
  include panos
  include device_manager::devices
}
