# install sensu server

#
class minifox::policy::app::sensu {
  include minifox::policy::app::sensu::server
  include minifox::policy::app::sensu::plugins
  include minifox::policy::app::sensu::checks
  include minifox::policy::app::sensu::handlers
}
