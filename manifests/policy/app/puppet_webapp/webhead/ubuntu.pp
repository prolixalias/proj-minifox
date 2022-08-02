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
#   Default value: facts['networking']['fqdn']
# @param [String] vhost_port
#   xxx
#   Default value: '8008'
# @param [String] doc_root
#   xxx
#   Default value: = '/var/www/flask'
# @param [String] app_env
#   xxx
#   Default value: = pick_default($facts['appenv'],'dev')

#
class minifox::policy::app::puppet_webapp::webhead::ubuntu (
  String $app_name = 'webui',
  String $app_version = '0.1.12',
  String $dist_file = "https://github.com/ipcrm/puppet_webapp/releases/download/${app_version}/puppet_webapp-${app_version}.tar.gz",
  String $vhost_name = $facts['networking']['fqdn'],
  String $vhost_port = '8008',
  String $doc_root = '/var/www/flask',
  String $app_env  = pick_default($facts['appenv'],'dev')
) {
  package { 'apache2':
    ensure   => purged,
    provider => 'apt',
  }

  $_local_archive = basename($dist_file)

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

  class { 'python' :
    version    => 'system',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
    gunicorn   => 'present',
  }

  package { 'flask':
    ensure   => present,
    provider => 'pip',
    require  => Class['python'],
  }

  python::gunicorn { 'vhost':
    ensure    => present,
    mode      => 'wsgi',
    dir       => '/var/www/flask',
    bind      => "0.0.0.0:${vhost_port}",
    appmodule => 'webui:webui',
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
    ],
    notify  => Service['gunicorn'],
  }

  firewall { "110 allow http ${vhost_port}  access":
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
