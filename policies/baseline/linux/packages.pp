# @summary This profile installs unzip and git as part of the Linux baseline
class policy::baseline::linux::packages {

  $pkgs = ['unzip','wget']

  $pkgs.each |$package| {
    package { $package:
      ensure => installed,
    }
  }

  if getvar('facts.osfamily') == 'RedHat' {
    include epel
  }

  unless getvar('trusted.external.servicenow.u_enforced_packages').empty {
    $packages = getvar('trusted.external.servicenow.u_enforced_packages').parsejson
    $packages.each |$package,$ensure|{
      package { $package:
        ensure => $ensure
      }
    }
  }
}
