class python {
  package { [ 'python3', 'python3-devel' ]:
    ensure   => 'installed',
    provider => "yum"
  }
}
