class weather_api {
  package { 'flask':
    ensure   => 'installed',
    provider => pip3
  }
  file { '/etc/nginx/conf.d/weather_api.conf':
    ensure  => file,
    notify => Service['nginx'],
    owner   => 'root',
    group   => 'root',
    mode    => '640',
    source => 'puppet:///modules/weather_api/weather_api.nginx.conf',
    require => Package['nginx']
  }
  file { '/etc/uwsgi/vassals/weather_api.conf':
    ensure  => present,
    notify => Service['emperor.uwsgi'],
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    source => 'puppet:///modules/weather_api/weather_api.uwsgi.conf'
  }
}
