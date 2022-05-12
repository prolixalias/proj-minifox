# @summary This is a baseline policy applied to all IT systems

# The baseline policy ensures required security and compliance products are
# installed.
#
# @param required
#   This parameter is not useful, but is required
#
# @param enable_monitoring
#   Whether or not basic OS monitoring will be configured on this instance.
#   Defaults to false.
#
# @param complex
#   This parameter has a complex type, but is not required.
#
class policy::baseline (
  $untyped,
  String $required,
  Boolean $enable_monitoring = false,
  Optional[Variant[String, Array]] $complex = undef,
) {

  # Global
  include policy::baseline::time

  # add sensu client
  if $enable_monitoring {
    include policy::app::sensu::client
  }

  # OS Specific
  case getvar('facts.kernel') {
    'windows': {
      include policy::baseline::windows
    }
    'Linux':   {
      include policy::baseline::linux
    }
    default: {
      fail('Unsupported operating system!')
    }
  }

}
