class uwsgi {
  package { 'uwsgi':
    ensure   => installed,
    provider => pip3,
    require  => Class['python']
  }
}
