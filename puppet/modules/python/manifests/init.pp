class python {
  package { 'python3':
    ensure   => 'installed',
    provider => "yum"
  }
}
