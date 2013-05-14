class nginx {

   exec { 'nginxPrepare':
   	command => 'add-apt-repository -y ppa:nginx/stable ',
    	require => Package['python-software-properties'],
  }

  $packages = [ "nginx" ]
  package { $packages:
    ensure => "installed",
    require => Exec['nginxPrepare','apt-get update']
  }

    # Enable the nginx service
    service { "apache2":
        enable => false,
        ensure => stopped,
        require => Package["nginx"],
    }


    # Enable the nginx service
    service { "nginx":
        enable => true,
        ensure => running,
        require => Service["apache2"],
    }

    # Change configuration files
    file { "/etc/nginx/nginx.conf":
        ensure => file,
        owner => "root",
        group => "root",
        source => "puppet:///modules/nginx/nginx.conf",
        require => Package['nginx'],
    }

}