class base {
  $apt_proxy = ""
  if $apt_proxy {
    file { 'apt-get proxy config':
      before  => Exec['apt-get update', 'apt-get dist-upgrade'],
      path    => '/etc/apt/apt.conf.d/00proxy',
      ensure  => present,
      content => "Acquire::http::Proxy \"${apt_proxy}\";\n"
    }
  }
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }
  exec { 'apt-get dist-upgrade':
    require => Exec['apt-get update'],
    command => '/usr/bin/apt-get dist-upgrade --yes'
  }
}

class checkbox_ng {
  package {
    "python-software-properties":   ensure => installed
  }
  exec { 'Enable PPA checkbox-dev/ppa':
    require => Package['python-software-properties'],
    before  => Exec['apt-get update', 'apt-get dist-upgrade'],
    command => "/usr/bin/add-apt-repository --yes ppa:checkbox-dev/ppa",
    onlyif  => "/usr/bin/test ! -e /etc/apt/sources.list.d/checkbox-dev-ppa-precise.list",
  }
  package { "plainbox-insecure-policy":
    require => [
      Exec['Enable PPA checkbox-dev/ppa'],
      Exec['apt-get update']
    ],
    ensure => installed
  }
  package { "checkbox-ng":
    require => [
      Exec['Enable PPA checkbox-dev/ppa'],
      Exec['apt-get update']
    ],
    ensure => installed
  }
}

include base
include checkbox_ng 
