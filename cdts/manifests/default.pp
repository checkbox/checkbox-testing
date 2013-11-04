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

class ubuntu_sdk {
  exec { "Enable PPA canonical-qt5-edgers/qt5-proper":
    require => Package['python-software-properties'],
    before  => Exec['apt-get update', 'apt-get dist-upgrade'],
    command => "/usr/bin/add-apt-repository --yes ppa:canonical-qt5-edgers/qt5-proper"
  }
  exec { "Enable PPA ubuntu-sdk-team/ppa":
    require => Package['python-software-properties'],
    before  => Exec['apt-get update', 'apt-get dist-upgrade'],
    command => "/usr/bin/add-apt-repository --yes ppa:ubuntu-sdk-team/ppa"
  }
}

class cdts {
  # Secret ppa credentials, user:password
  $ppa_secret = ""
  package {
    "python-software-properties":   ensure => installed
  }
  exec { 'Enable PPA checkbox-dev/ppa':
    require => Package['python-software-properties'],
    before  => Exec['apt-get update', 'apt-get dist-upgrade'],
    command => "/usr/bin/add-apt-repository --yes ppa:checkbox-dev/ppa"
  }
  exec { 'Enable PPA checkbox-ihv-ng/private-ppa':
    require => Package['python-software-properties'],
    before  => Exec['apt-get update', 'apt-get dist-upgrade'],
    command => "/usr/bin/add-apt-repository --yes 'deb https://${ppa_secret}@private-ppa.launchpad.net/checkbox-ihv-ng/private-ppa/ubuntu precise main'"
  }
  package { "canonical-driver-test-suite":
    require => [
      Exec['Enable PPA checkbox-ihv-ng/private-ppa'],
      Exec['Enable PPA ubuntu-sdk-team/ppa'],
      Exec['Enable PPA canonical-qt5-edgers/qt5-proper'],
      Exec['apt-get update']
    ],
    ensure => installed
  }
}

include base
include ubuntu_sdk
include cdts 
