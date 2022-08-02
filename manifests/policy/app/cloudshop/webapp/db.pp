#

# @param [String] dbinstance
#   xxx
#   Default value: 'MYINSTANCE'
# @param [String] dbpass
#   xxx
#   Default value: 'Azure$123'
# @param [String] dbuser
#   xxx
#   Default value: 'CloudShop'
# @param [String] dbname
#   xxx
#   Default value: 'AdventureWorks2012'
# @param [String] dbserver
#   xxx
#   Default value: $facts['networking']['hostname']
# @param [String] file_source
#   xxx
#   Default value: 'https://s3-us-west-2.amazonaws.com/tseteam/files/sqlwebapp'

#
class minifox::policy::app::cloudshop::webapp::db (
  String $dbinstance = 'MYINSTANCE',
  String $dbpass = 'Azure$123',
  String $dbuser = 'CloudShop',
  String $dbname = 'AdventureWorks2012',
  String $dbserver = $facts['networking']['hostname'], # $::fqdn doesn't work on Windows / AWS
  String $file_source = 'https://s3-us-west-2.amazonaws.com/tseteam/files/sqlwebapp',
) {
  minifox::policy::app::cloudshop::sqlserver::attachdb { $dbname:
    file_source => $file_source,
    dbinstance  => $dbinstance,
    dbpass      => $dbpass,
    owner       => $dbuser,
  }
}
