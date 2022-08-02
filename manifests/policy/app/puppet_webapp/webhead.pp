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
#   Default value: pick_default($facts['appenv'],'dev')

#
class minifox::policy::app::puppet_webapp::webhead (
  String $app_env = pick_default($facts['appenv'],'dev'),
  String $app_name = 'webui',
  String $app_version = '0.1.12',
  String $dist_file = "https://github.com/ipcrm/puppet_webapp/releases/download/${app_version}/puppet_webapp-${app_version}.tar.gz",
  String $doc_root = '/var/www/flask',
  String $vhost_name = $facts['networking']['fqdn'],
  String $vhost_port = '8008',
) {
  $options = {
    app_name    => $app_name,
    app_version => $app_version,
    dist_file   => $dist_file,
    vhost_name  => $vhost_name,
    vhost_port  => $vhost_port,
    doc_root    => $doc_root,
    app_env     => $app_env,
  }

  case $facts['os']['family'] {
    'Debian': {
      class { 'minifox::policy::app::puppet_webapp::webhead::ubuntu':
        * => $options,
      }
    }

    'RedHat': {
      class { 'minifox::policy::app::puppet_webapp::webhead::rhel':
        * => $options,
      }
    }

    default: {
      fail('Unsupported OS')
    }
  }
}
