#

# @param [String] masterurl
#   xxx
# @param [String] ui_user
#   xxx
# @param [String] ui_pass
#   xxx
# @param [Integer] executors
#   xxx
#   Default value: 1
# @param [String] labels
#   xxx
#   Default value: undef
# @param [String] slave_home
#   xxx
#   Default value: 'C:/jenkins'
# @param [String] slave_version
#   xxx
#   Default value: '2.0'
# @param [String] client_jar
#   xxx
#   Default value: 'swarm-client-2.0-jar-with-dependencies.jar'
# @param [String] jenkins_owner
#   xxx
#   Default value: 'jenkins'

#
class minifox::policy::app::jenkins::win_slave (
  String $masterurl,
  String $ui_user,
  String $ui_pass,
  Integer $executors = 1,
  String $labels = undef,
  String $slave_home = 'C:/jenkins',
  String $slave_version = '2.0',
  String $client_jar = 'swarm-client-2.0-jar-with-dependencies.jar',
  String $jenkins_owner = 'jenkins',
) {
  include minifox::policy::baseline

  $client_url = "https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${slave_version}/"

  $client_jar_flag  = "-jar ${slave_home}/${client_jar}"
  $mode_flag        = '-mode normal'
  $fs_root_flag     = "-fsroot ${slave_home}"
  $executors_flag   = "-executors ${executors}"
  $ui_user_flag     = "-username ${ui_user}"
  $ui_pass_flag     = "-password ${ui_pass}"
  $slave_alias_flag = "-name ${facts['networking']['fqdn']}"
  $master_url_flag  = "-master ${masterurl}"
  $labels_flag      = "-labels ${labels}"

  package { ['javaruntime','wget']:
    ensure   => installed,
    provider => chocolatey,
  }

  user { $jenkins_owner:
    ensure     => present,
    home       => $slave_home,
    password   => 'S3cr3tP@$$w0rd',
    managehome => true,
    groups     => ['Administrators'],
    comment    => 'Jenkins User',
  }

  file { $slave_home:
    ensure  => directory,
    owner   => 'S-1-5-32-544', # BUILTIN\Administrators
    group   => 'S-1-0-0',      # NULL, managed by acl resource below
    require => User[$jenkins_owner],
  }

  acl { $slave_home:
    permissions                => [
      { identity => 'S-1-5-32-544',  rights => ['full'] }, # BUILTIN\Administrators
      { identity => 'S-1-5-18',      rights => ['full'] }, # NT AUTHORITY\SYSTEM
      { identity => 'Administrator', rights => ['full'] },
      { identity => $jenkins_owner,  rights => ['full'] },
    ],
    inherit_parent_permissions => false,
    require                    => File[$slave_home],
  }

  exec { 'download-swarm-client':
    command => "wget.exe -O ${slave_home}/${client_jar} ${client_url}/${client_jar}",
    path    => "c:/programdata/chocolatey/bin;${facts['path']}",
    creates => "${slave_home}/${client_jar}",
    notify  => Exec['uninstall-jenkins-service'],
  }

  file { "${slave_home}/${client_jar}":
    ensure  => file,
    owner   => $jenkins_owner,
    group   => 'S-1-5-32-544',  # Administrators
    mode    => '0775',
    require => Exec['download-swarm-client'],
  }

  # Let's install the service.
  file { "${slave_home}/swarm-client.xml":
    content => template('profile/app/jenkins/swarm-client-win.xml.erb'),
    notify  => Exec['uninstall-jenkins-service'],
    require => User[$jenkins_owner],
  }

  file { "${slave_home}/swarm-client.exe.config":
    source  => 'puppet:///modules/profile/app/jenkins/swarm-client-win.config',
    owner   => $jenkins_owner,
    group   => 'S-1-5-32-544',  # Administrators
    mode    => '0775',
    notify  => Exec['uninstall-jenkins-service'],
    require => User[$jenkins_owner],
  }

  # Its binary, but only 37k.  Used to setup a service.
  # see: https://github.com/kohsuke/winsw
  file { "${slave_home}/swarm-client.exe":
    source  => 'puppet:///modules/profile/app/jenkins/swarm-client-win.exe',
    owner   => $jenkins_owner,
    group   => 'S-1-5-32-544',  # Administrators
    mode    => '0775',
    notify  => Exec['uninstall-jenkins-service'],
    require => [
      File["${slave_home}/swarm-client.xml"],
      File["${slave_home}/swarm-client.exe.config"],
    ],
  }

  exec { 'install-jenkins-service':
    path     => "c:/windows/system32;${slave_home}",
    command  => "${slave_home}/swarm-client.exe install",
    unless   => '$t = (Get-Service jenkins-slave -ErrorAction SilentlyContinue); if (-Not $t){ exit 1 } else { exit 0 }',
    provider => powershell,
    require  => [
      Exec['download-swarm-client'],
      File["${slave_home}/swarm-client.exe"],
    ],
  }

  exec { 'uninstall-jenkins-service':
    path        => "c:/windows/system32;${slave_home}",
    command     => 'net stop jenkins-slave & sc.exe delete jenkins-slave',
    onlyif      => '$t = (Get-Service jenkins-slave -ErrorAction SilentlyContinue); if (-Not $t){ exit 1 } else { exit 0 }',
    provider    => powershell,
    refreshonly => true,
    returns     => [0, 1],
    notify      => Exec['install-jenkins-service'],
    logoutput   => true,
  }

  windows_env { 'git-on-path':
    ensure    => present,
    variable  => 'PATH',
    value     => [
      'C:\Program Files\Git\cmd',
      'C:\Program Files (x86)\Git\cmd',
    ],
    mergemode => 'prepend',
    require   => Package['git'],
  }

  service { 'jenkins-slave':
    ensure  => running,
    enable  => true,
    require => Exec['install-jenkins-service'],
  }
}
