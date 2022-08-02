# @param [String] sqlserver_version
#   xxx
#   Default value: '2014'
# @param [Booolean] mount_iso
#   xxx
#   Default value: true

# Main class that declares SQL, IISDB, and creates an
# instance of the attachDB defined type.

#
class minifox::policy::app::cloudshop::sqlserver::init (
  String $sqlserver_version = '2014',
  Booolean $mount_iso = true,
) {
  if $mount_iso {
    contain minifox::policy::app::cloudshop::sqlserver::mount
    Class['minifox::policy::app::cloudshop::sqlserver::mount'] -> Class['minifox::policy::app::cloudshop::sqlserver::sql']
  }

  contain minifox::policy::app::cloudshop::sqlserver::sql
}
