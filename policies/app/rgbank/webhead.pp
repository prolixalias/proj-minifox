class policy::app::rgbank::webhead {

  class{'::policy::app::webserver::nginx':
    php => true,
  }

  file { 'default-nginx-disable':
    ensure  => absent,
    path    => '/etc/nginx/conf.d/default.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  include ::policy::app::db::mysql::client

}
