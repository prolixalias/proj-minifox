#

#
class minifox::policy::app::rgbank::webhead {
  class { 'minifox::policy::app::webserver::nginx':
    php => true,
  }

  file { 'default-nginx-disable':
    ensure  => absent,
    path    => '/etc/nginx/conf.d/default.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  include minifox::policy::app::db::mysql::client
}
