class policy::app::java::linux (
  $distribution,
){

  class { '::java':
    distribution => $distribution,
  }

}
