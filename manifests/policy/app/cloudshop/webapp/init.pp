#

# @param [String] dbserver
#   xxx
#   Default value: $facts['networking']['hostname']
# @param [String] dbinstance
#   xxx
#   Default value:  'MYINSTANCE'
# @param [String] dbpass
#   xxx
#   Default value:  'Azure$123'
# @param [String] dbuser
#   xxx
#   Default value:  'CloudShop'
# @param [String] dbname
#   xxx
#   Default value:  'AdventureWorks2012'
# @param [String] iis_site
#   xxx
#   Default value:  'Default Web Site'
# @param [String] docroot
#   xxx
#   Default value:  'C:/inetpub/wwwroot'
# @param [String] file_source
#   xxx
#   Default value:  'https://s3-us-west-2.amazonaws.com/tseteam/files/sqlwebapp'

#
class minifox::policy::app::cloudshop::webapp::init (
  String $dbserver = $facts['networking']['hostname'], # on Windows / AWS. $::fqdn doesn't work
  String $dbinstance = 'MYINSTANCE',
  String $dbpass = 'Azure$123',
  String $dbuser = 'CloudShop',
  String $dbname = 'AdventureWorks2012',
  String $iis_site = 'Default Web Site',
  String $docroot = 'C:/inetpub/wwwroot',
  String $file_source = 'https://s3-us-west-2.amazonaws.com/tseteam/files/sqlwebapp',
) {
  require minifox::policy::app::cloudshop::webapp::iis

  file { "${docroot}/CloudShop":
    ensure  => directory,
  }

  staging::file { 'CloudShop.zip':
    source => "${file_source}/CloudShop.zip",
  }

  unzip { 'Unzip webapp CloudShop':
    source      => "${facts['staging_windir']}/${module_name}/CloudShop.zip",
    creates     => "${docroot}/CloudShop/Web.config",
    destination => "${docroot}/CloudShop",
    require     => Staging::File['CloudShop.zip'],
  }

  file { "${docroot}/CloudShop/Web.config":
    ensure  => file,
    content => template('profile/cloudshop/Web.config.erb'),
    require => Unzip['Unzip webapp CloudShop'],
    notify  => Exec['ConvertAPP'],
  }

  exec { 'ConvertAPP':
    command     => "ConvertTo-WebApplication \'IIS:/Sites/${iis_site}/CloudShop\'",
    provider    => powershell,
    refreshonly => true,
  }
}
