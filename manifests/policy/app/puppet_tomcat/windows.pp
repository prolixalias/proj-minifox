#

# @param [Array] tomcat_other_versions
#   xxx
# @param [String] plsample_version
#   xxx
# @param [String] tomcat_version
#   xxx
# @param [Boolean] deploy_sample_app
#   xxx
#   Default value: true

#
class minifox::policy::app::puppet_tomcat::windows (
  Array  $tomcat_other_versions,
  String $plsample_version,
  String $tomcat_version,
  Boolean $deploy_sample_app = true,
) {
  $tomcat_major_version = split($tomcat_version, '[.]')[0]

  class { 'policy::app::java':
    distribution => 'jre',
  }

  windows_firewall::exception { 'Tomcat':
    ensure       => present,
    direction    => 'in',
    action       => 'allow',
    enabled      => true,
    protocol     => 'TCP',
    local_port   => 8080,
    display_name => 'Apache Tomcat Port',
    description  => 'Inbound rule for Tomcat',
  }

  remote_file { "C:/apache-tomcat-${tomcat_version}.exe":
    ensure => present,
    source => "http://${facts['puppet_server']}:81/tomcat/apache-tomcat-${tomcat_version}.exe",
    before => Package["Apache Tomcat ${tomcat_major_version}.0 Tomcat${tomcat_major_version} (remove only)"],
  }

  $tomcat_other_versions.each |String $version| {
    exec { "remove tomcat ${version}":
      command => "\"C:/Program Files/Apache Software Foundation/Tomcat ${version}.0/Uninstall.exe\" /S -ServiceName=tomcat${version}",
      unless  => "cmd.exe /c if exist \"C:\\Program Files\\Apache Software Foundation\\Tomcat ${version}.0\\Uninstall.exe\" (exit /b 1)",
      path    => 'C:\windows\system32;C:\windows',
      before  => Package["Apache Tomcat ${tomcat_major_version}.0 Tomcat${tomcat_major_version} (remove only)"],
    }
  }

  package { "Apache Tomcat ${tomcat_major_version}.0 Tomcat${tomcat_major_version} (remove only)":
    ensure          => present,
    source          => "C:/apache-tomcat-${tomcat_version}.exe",
    install_options => ['/S'],
  }

  service { "tomcat${tomcat_major_version}":
    ensure  => running,
    enable  => true,
    require => Package["Apache Tomcat ${tomcat_major_version}.0 Tomcat${tomcat_major_version} (remove only)"],
  }

  if $deploy_sample_app == true {
    remote_file {
      "C:/Program Files/Apache Software Foundation/Tomcat ${tomcat_major_version}.0/webapps/plsample-${plsample_version}.war":
        ensure  => latest,
        source  => "http://${facts['puppet_server']}:81/tomcat/plsample-${plsample_version}.war",
        require => Service["tomcat${tomcat_major_version}"],
    }
  }
}
