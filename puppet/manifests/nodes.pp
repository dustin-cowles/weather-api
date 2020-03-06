node default {
  include python
  include nginx
  include uwsgi
  include weather_api
}
