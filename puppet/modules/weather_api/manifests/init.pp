class weather_api {
  package { 'flask':
    ensure   => 'installed',
    provider => pip3
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
  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    notify  => Service['nginx'],
    owner   => 'root',
    group   => 'root',
    mode    => '640',
    source  => 'puppet:///modules/weather_api/weather_api.nginx.conf',
    require => Package['nginx']
  }
  file { '/var/www/weather_api/weather_api.ini':
    ensure => present,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0600',
    source => 'puppet:///modules/weather_api/weather_api.uwsgi.ini',
    require => [ User['www-data'], Group['www-data'] ]
  }
  file { [ '/var/www/weather_api', '/var/log/weather_api', '/var/run/weather_api/' ]:
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    recurse => true,
    require => [ User['www-data'], Group['www-data'] ]
  }
  file { '/etc/systemd/system/weather_api.service':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/weather_api/weather_api.service'
  }
  service { 'weather_api':
    ensure  => running,
    enable  => true,
    require => [ File['/etc/systemd/system/weather_api.service'], File['/var/www/weather_api/weather_api.ini'] ]
  }
}
