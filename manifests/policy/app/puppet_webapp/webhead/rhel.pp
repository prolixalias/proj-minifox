#

# @param [String] app_name
#   xxx
#   Default value: 'webui'
# @param [String] app_version
#   xxx
#   Default value: '0.1.12'
# @param [String] dist_file
#   xxx
#   Default value: "https://github.com/ipcrm/puppet_webapp/releases/download/${app_version}/puppet_webapp-${app_version}.tar.gz"
# @param [String] vhost_name
#   xxx
#   Default value: $facts['networking']['fqdn']
# @param [String] vhost_port
#   xxx
#   Default value: '8008'
# @param [String] doc_root
#   xxx
#   Default value: '/var/www/flask'
# @param [String] app_env
#   xxx
#   Default value: pick_default($::appenv,'dev')

#
class minifox::policy::app::puppet_webapp::webhead::rhel (
  String $app_name = 'webui',
  String $app_version = '0.1.12',
  String $dist_file = "https://github.com/ipcrm/puppet_webapp/releases/download/${app_version}/puppet_webapp-${app_version}.tar.gz",
  String $vhost_name = $facts['networking']['fqdn'],
  String $vhost_port = '8008',
  String $doc_root = '/var/www/flask',
  String $app_env  = pick_default($facts['appenv'],'dev')
) {
  require minifox::policy::baseline

  class { 'policy::app::webserver::apache':
    default_vhost => false,
  }

  $_local_archive = basename($dist_file)

  package { 'python-pip':
    ensure => present,
  }

  package { 'flask':
    ensure   => present,
    provider => 'pip',
    require  => Package['python-pip'],
  }

  file { '/var/www':
    ensure => directory,
    mode   => '0755',
  }

  file { $doc_root:
    ensure => directory,
    mode   => '0755',
  }

  file { "${doc_root}/wsgi.py":
    ensure  => file,
    mode    => '0755',
    content => template('profile/app/puppet_webapp_wsgi.py.erb'),
  }

  apache::vhost { $vhost_name:
    port                        => $vhost_port,
    docroot                     => $doc_root,
    wsgi_application_group      => '%{GLOBAL}',
    wsgi_daemon_process         => 'wsgi',
    wsgi_daemon_process_options => {
      processes    => '2',
      threads      => '15',
      display-name => '%{GROUP}',
    },
    wsgi_import_script          => "${doc_root}/wsgi.py",
    wsgi_import_script_options  => {
      process-group     => 'wsgi',
      application-group => '%{GLOBAL}',
    },
    wsgi_process_group          => 'wsgi',
    wsgi_script_aliases         => {
      '/' => "${doc_root}/wsgi.py",
    },
  }

  exec { 'retrieve sdist':
    path    => $facts['path'],
    command => "curl -L -o /usr/local/src/${_local_archive} \'${dist_file}\'",
    creates => "/usr/local/src/${_local_archive}",
  }

  exec { 'remove puppet-webapp if wrong version':
    path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    command => 'pip uninstall --yes puppet-webapp',
    unless  => "pip list | grep puppet-webapp | grep ${app_version}",
    onlyif  => 'pip list | grep puppet-webapp',
    notify  => Exec["pip install ${_local_archive}"],
  }

  exec { "pip install ${_local_archive}":
    path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    command => "pip install /usr/local/src/${_local_archive} --ignore-installed --no-deps",
    unless  => 'pip list | grep puppet-webapp',
    require => [
      Exec['retrieve sdist'],
      Exec['remove puppet-webapp if wrong version'],
      Class['apache'],
    ],
    notify  => Class['Apache::Service'],
  }

  firewall { "110 allow http ${vhost_port} access":
    dport  => $vhost_port,
    proto  => tcp,
    action => accept,
  }

  @@haproxy::balancermember { "haproxy-${facts['networking']['fqdn']}":
    listening_service => "${app_env}_bk",
    ports             => $vhost_port,
    server_names      => $facts['networking']['hostname'],
    ipaddresses       => $facts['networking']['ip'],
    options           => 'check',
  }
}
