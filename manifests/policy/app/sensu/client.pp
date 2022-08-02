#

# @param [Array[String]] subscriptions
#   xxx
# @param [String] rabbitmq_host
#   xxx
# @param [String] rabbitmq_password
#   xxx
# @param [String] rabbitmq_user
#   xxx
# @param [String] rabbitmq_vhost
#   xxx

#
class minifox::policy::app::sensu::client (
  Array[String] $subscriptions,
  String $rabbitmq_host,
  String $rabbitmq_password,
  String $rabbitmq_user,
  String $rabbitmq_vhost,
) {
  include policy::app::sensu::plugins

  Host  <<| tag == 'sensu-server' |>>

  class { 'sensu':
    rabbitmq_user     => $rabbitmq_user,
    rabbitmq_password => $rabbitmq_password,
    rabbitmq_vhost    => $rabbitmq_vhost,
    rabbitmq_host     => $rabbitmq_host,
    client            => true,
    subscriptions     => $subscriptions,
  }
}
