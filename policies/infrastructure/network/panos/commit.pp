class policy::infrastructure::network::panos::commit {
  panos_commit {
    'commit':
      commit => true
  }
}
