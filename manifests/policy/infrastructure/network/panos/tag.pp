#

# @param [String] color
#   xxx
#   Default value: 'blue'
# @param [String] comments
#   xxx
#   Default value: 'Default from manifest'
# @param [String] ensure
#   xxx
#   Default value: 'present'

#
class minifox::policy::infrastructure::network::panos::tag (
  String $color = 'blue',
  String $comments = 'Default from manifest',
  String $ensure = 'present',
) {
  panos_tag { 'demo':
    ensure   => $ensure,
    color    => $color,
    comments => $comments,
  }
}
