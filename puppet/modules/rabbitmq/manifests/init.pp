class rabbitmq {
    # Install mysql
    package { "rabbitmq-server":
        ensure => latest,
        require => Exec['apt-get update']
    }

    # Enable the  service
    service { "rabbitmq-server":
        enable => true,
        ensure => running,
        require => Package["rabbitmq-server"],
    }

}