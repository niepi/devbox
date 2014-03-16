class mongodb {
    # Install mysql
    package { "mongodb":
        ensure => latest,
        require => Exec['apt-get update'],
    }

    # Enable the Mongo service
    service { "mongodb":
        enable => true,
        ensure => running,
        require => Package["mongodb"],
    }

    file { "/etc/mongodb.conf":
        ensure => present,
        group => "root",
        owner => "root",
        mode => "0644",
        source => "puppet:///modules/mongodb/mongodb.conf",
        require => Package["mongodb"],
        notify => Service["mongodb"],
    }
}