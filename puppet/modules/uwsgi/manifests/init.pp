class uwsgi {
  $launch_params = {
    'uid'         => 'www-data',
    'gid'         => 'www-data',
    'socket'      => '/tmp/uwsgi.sock',
    'logdate'     => '',
    'optimize'    => 2,
    'processes'   => 2,
    'master'      => '',
    'die-on-term' => '',
    'logto'       => '/var/log/uwsgi.log',
    'chdir'       => '/var/www-data/weather_api',
    'module'      => 'weather_api',
    'callable'    => 'APP',
  }
  package { 'uwsgi':
    ensure   => installed,
    provider => pip3,
    require  => Class['python']
  }
  group { 'www-data':
    ensure => present,
    gid    => 1011
  }
  user { 'www-data':
    ensure  => present,
    groups  => ['www-data'],
    uid     => 1011,
    require => Group['www-data']
  }
  file { [ '/etc/uwsgi', '/etc/uwsgi/vassals' ]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file { '/var/www/weather_api':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    recurse => true,
    require => [ User['www-data'], Group['www-data'] ]
  }
  file { '/etc/uwsgi/emperor.ini':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source => 'puppet:///modules/uwsgi/emperor.ini'
  }
  file { '/etc/systemd/system/emperor.uwsgi.service':
    ensure  => present,
    notify => Service['emperor.uwsgi'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source => 'puppet:///modules/uwsgi/emperor.uwsgi.service',
    require => File['/etc/uwsgi/emperor.ini']
  }
  service { 'emperor.uwsgi':
    ensure  => running,
    enable  => true,
    require => File['/etc/systemd/system/emperor.uwsgi.service']
  }
}
