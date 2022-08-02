#
# @param [String] distribution
#   xxx
#
class minifox::policy::app::java::linux (
  String $distribution,
) {
  class { 'java':
    distribution => $distribution,
  }
}
