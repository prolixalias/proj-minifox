# @summary This is a baseline policy applied to all IT systems

# The baseline policy ensures required security and compliance products are
# installed.
#
# @param [Boolean] enable_monitoring
#   Whether or not basic OS monitoring will be configured on this instance.
#   Defaults to false.
#

#
class minifox::policy::baseline (
  Boolean $enable_monitoring = false,
) {
  include minifox::policy::baseline::time

  # add sensu client
  if $enable_monitoring {
    include minifox::policy::app::sensu::client
  }

  # OS Specific
  case getvar('facts.kernel') {
    'Darwin':   {
      include minifox::policy::baseline::darwin
    }
    'Linux':   {
      include minifox::policy::baseline::linux
    }
    'windows': {
      include minifox::policy::baseline::windows
    }
    default: {
      fail("Encountered unexpected kernel: ${facts['kernel']}")
    }
  }
}
