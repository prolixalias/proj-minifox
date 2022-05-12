# configure puppet device
class policy::infrastructure::network::device_manager {
  include panos
  include device_manager::devices
}
