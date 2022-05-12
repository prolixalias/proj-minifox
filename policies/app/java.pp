class policy::app::java (
  $distribution = 'jre',
){

  case $::kernel {

    'windows': {
      class{'::policy::app::java::windows':
        distribution => $distribution,
      }
    }

    'Linux': {
      class{'::policy::app::java::linux':
        distribution => $distribution,
      }
    }

    default:   {
      fail('Unsupported kernel detected')
    }

  }

}
