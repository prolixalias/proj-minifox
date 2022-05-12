# Main class that declares SQL, IISDB, and creates an
# instance of the attachDB defined type.
class policy::app::cloudshop::sqlserver::init (
  $sqlserver_version = '2014',
  $mount_iso = true,
) {

  if $mount_iso {
    contain policy::app::cloudshop::sqlserver::mount
    Class['policy::app::cloudshop::sqlserver::mount'] -> Class['policy::app::cloudshop::sqlserver::sql']
  }

  contain policy::app::cloudshop::sqlserver::sql
}
