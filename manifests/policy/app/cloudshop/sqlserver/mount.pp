# This class is used to mount an ISO containing the SQL Server 2014 Code.

# @param [String] iso
#   xxx
#   Default value: 'SQLServer2014-x64-ENU.iso'
# @param [String] iso_source
#   xxx
#   Default value: 'https://s3-us-west-2.amazonaws.com/tseteam/files/tse_sqlserver'
# @param [String] iso_drive
#   xxx
#   Default value: 'F'

#
class minifox::policy::app::cloudshop::sqlserver::mount (
  String $iso = 'SQLServer2014-x64-ENU.iso',
  String $iso_source = 'https://s3-us-west-2.amazonaws.com/tseteam/files/tse_sqlserver',
  String $iso_drive = 'F'
) {
  include minifox::policy::app::cloudshop::sqlserver::staging

  staging::file { $iso:
    source  => "${iso_source}/${iso}",
    timeout => 600, # default 300
  }

  $iso_path = "${facts['staging::path']}/${module_name}/${iso}"

  acl { $iso_path :
    permissions => [
      {
        identity => 'Everyone',
        rights   => ['full'],
      },
      {
        identity => $facts['staging::owner'],
        rights   => ['full'],
      },
    ],
    require     => Staging::File[$iso],
    before      => Mount_iso[$iso_path],
  }

  mount_iso { $iso_path :
    drive_letter => $iso_drive,
  }
}
