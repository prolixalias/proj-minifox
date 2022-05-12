# install sensu server
class policy::app::sensu {
  include policy::app::sensu::server
  include policy::app::sensu::plugins
  include policy::app::sensu::checks
  include policy::app::sensu::handlers
}
