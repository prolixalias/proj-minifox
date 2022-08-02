#

# @param [Enum['present','absent']] ensure
#   xxx
#   Default value: present
# @param [Enum['yes','no']] value
#   xxx
#   Default vaLue: 'yes'

#
class minifox::policy::app::ssh::permitrootlogin (
  Enum['present','absent'] $ensure = present,
  Enum['yes','no'] $value = 'yes',
) {
  sshd_config { 'PermitRootLogin':
    ensure => $ensure,
    value  => $value,
  }
}
