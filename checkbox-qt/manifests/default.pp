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

class theme {
  file { 'background':
    path    => "/usr/share/backgrounds/UnderConstruction.png",
    ensure  => present,
    source  => "/vagrant/files/UnderConstruction.png"
  }
  exec { 'set custom background (Gnome 2)':
    require => [
      File['background'],
    ],
    command => "/bin/sh -c 'DISPLAY=:0 gconftool-2 --type=string --set /desktop/gnome/background/picture_filename /usr/share/backgrounds/UnderConstruction.png'",
    onlyif  => "/usr/bin/test -e /usr/bin/gconftool-2",
    user    => 'vagrant',
  }
  exec { 'set custom background (Gnome 3)':
    require => [
      File['background'],
    ],
    command => "/bin/sh -c 'DISPLAY=:0 gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/UnderConstruction.png'",
    onlyif  => "/usr/bin/test -e /usr/bin/gsettings",
    user    => 'vagrant',
  }
  # This is just a way to work around the damn quoting/unquoting mess that inline shell causes
  file { 'customize-unity-launcher.sh':
    path    => "/usr/local/bin/customize-unity-launcher.sh",
    mode    => 0755,
    ensure  => present,
    content => "dconf write /desktop/unity/launcher/favorites \"['checkbox-qt.desktop']\"",
  }
  file { 'customize-unity-launcher-check.sh':
    path    => "/usr/local/bin/customize-unity-launcher-check.sh",
    mode    => 0755,
    ensure  => present,
    content => "test \"$(dconf read /desktop/unity/launcher/favorites)\" != \"['checkbox-qt.desktop']\"",
  }
  exec { 'customize unity launcher':
    require => [
      Package['checkbox-qt'],
      File['customize-unity-launcher.sh']
    ],
    command => "/bin/sh -c 'DISPLAY=:0 /usr/local/bin/customize-unity-launcher.sh'",
    onlyif  => "/bin/sh -c 'DISPLAY=:0 /usr/local/bin/customize-unity-launcher-check.sh'",
    user    => 'vagrant',
  }
  exec { 'restart unity launcher':
    require => Exec['customize unity launcher'],
    command => '/usr/bin/killall unity-2d-shell',
    user    => 'vagrant'
  }
}

class checkbox_qt {
  package {
    "python-software-properties":   ensure => installed
  }
  exec { 'Enable PPA checkbox-dev/ppa':
    require => Package['python-software-properties'],
    before  => Exec['apt-get update', 'apt-get dist-upgrade'],
    command => "/usr/bin/add-apt-repository --yes ppa:checkbox-dev/ppa",
    onlyif  => "/usr/bin/test ! -e /etc/apt/sources.list.d/checkbox-dev-ppa-precise.list",
  }
  package { "checkbox-qt":
    require => [
      Exec['Enable PPA checkbox-dev/ppa'],
      Exec['apt-get update']
    ],
    ensure => installed
  }
}

include base
include theme
include checkbox_qt 
