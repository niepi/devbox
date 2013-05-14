class mongodb {
    # Install mysql
    package { "mongodb":
        ensure => latest,
        require => Exec['apt-get update']
    }

    # Enable the Mongo service
    service { "mongodb":
        enable => true,
        ensure => running,
        require => Package["mongodb"],
    }

}