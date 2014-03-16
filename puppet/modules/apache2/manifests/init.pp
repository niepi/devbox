class apache2 {
    # Install apache
    package { ["apache2","libapache2-mod-php5"]:
        ensure => latest,
        require => Exec['apt-get update']
    }


    # Enable the apache service
    service { "apache2":
        enable => true,
        ensure => running,
        require => Package["apache2"],
    }

    exec { "enable mod_rewrite":
       command => 'a2enmod rewrite',
       require => Service['apache2']
   }

    exec { "enable mod_headers":
       command => 'a2enmod headers',
       require => Service['apache2']
   }

    # Set the configuration
    file { "/etc/apache2/sites-enabled/000-default.conf":
        ensure => present,
        notify  => Service["apache2"],
        source => "puppet:///modules/apache2/vhost.conf",
        replace => true,
        require => Package['apache2'],
    }

}