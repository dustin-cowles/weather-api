class nginx {
  package { 'nginx':
    ensure => present
  }
  service { 'nginx':
    ensure => running,
    enable => true
  }
  file { '/etc/nginx/conf.d/weather_api.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '640',
    content => template('nginx/nginx.conf.erb'),
    require => Package['nginx']
  }
}
