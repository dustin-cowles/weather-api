class uwsgi {
  $launch_params = {
    "uid"         => "www-data",
    "gid"         => "www-data",
    "socket"      => "/tmp/uwsgi.sock",
    "logdate"     => "",
    "optimize"    => 2,
    "processes"   => 2,
    "master"      => "",
    "die-on-term" => "",
    "logto"       => "/var/log/uwsgi.log",
    "chdir"       => "/var/www-data/weather_api",
    "module"      => "weather_api",
    "callable"    => "APP",
  }
  package { "uwsgi":
    ensure   => installed,
    provider => pip3,
    require  => Class["python"]
  }
  group { 'www-data':
    ensure => present,
  }
  user { 'www-data':
    ensure  => present,
    groups  => ['www-data'],
    require => Group['www-data']
  }
  file { "/etc/uwsgi/emperor.ini":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "0600",
    content => template("uwsgi/emperor.ini.erb"),
    require => Package["uwsgi"]
  }
  file { "/etc/systemd/system/emperor.uwsgi.service":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "0600",
    content => template("uwsgi/emperor.uwsgi.service.erb"),
    require => File["/etc/uwsgi/emperor.ini"]
  }
  file { "/etc/uwsgi/vassals/weather_api.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "0600",
    content => template("default/weather_api.conf.erb")
  }
  service { "emperor.uwsgi":
    ensure  => running,
    enable  => true,
    require => [ File["/etc/systemd/system/emperor.uwsgi.service"], File["/etc/uwsgi/vassals/weather_api.conf"] ]
  }
}
