#

#
class minifox::policy::compliance::hipaa {
  case $facts['os']['family'] {
    'windows': {
      include minifox::policy::compliance::hipaa::windows
    }
    default: {
      include minifox::policy::compliance::hipaa::linux
    }
  }
}
