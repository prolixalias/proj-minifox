#
# @param [Boolean] deploy_sample_app
#   xxx
#   Default value: true
# @param [String] plsample_version
#   xxx
#   Default value: '1.0'
# @param [String] tomcat_major_version
#   xxx
#   Default value: '8'

#
class minifox::policy::app::puppet_tomcat (
  Boolean $deploy_sample_app = true,
  String $plsample_version = '1.0',
  String $tomcat_major_version = '8',
) {
  case $tomcat_major_version {
    '6': {
      $tomcat_version = '6.0.44'
      $catalina_dir = '/opt/apache-tomcat6'
      $tomcat_other_versions = ['7', '8']
    }
    '7': {
      $tomcat_version = '7.0.64'
      $catalina_dir = '/opt/apache-tomcat7'
      $tomcat_other_versions = ['6', '8']
    }
    '8': {
      $tomcat_version = '8.0.26'
      $catalina_dir = '/opt/apache-tomcat8'
      $tomcat_other_versions = ['6', '7']
    }
    default: {
      fail('Unsupported tomcat version!')
    }
  }

  case $facts['kernel'] {
    'Linux': {
      class { 'policy::app::puppet_tomcat::linux':
        deploy_sample_app     => $deploy_sample_app,
        plsample_version      => $plsample_version,
        tomcat_version        => $tomcat_version,
        catalina_dir          => $catalina_dir,
        tomcat_other_versions => $tomcat_other_versions,
      }
    }
    'windows': {
      class { 'policy::app::puppet_tomcat::windows':
        deploy_sample_app     => $deploy_sample_app,
        plsample_version      => $plsample_version,
        tomcat_version        => $tomcat_version,
        tomcat_other_versions => $tomcat_other_versions,
      }
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
