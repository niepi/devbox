class rabbitmq {
    # Install mysql
    package { "rabbitmq-server":
        ensure => latest,
        require => Exec['apt-get update'],
    }

    # Enable the  service
    service { "rabbitmq-server":
        enable => true,
        ensure => running,
        require => Package["rabbitmq-server"],
    }    

    exec { "rabbitmq-management":
        command => "sudo /usr/lib/rabbitmq/lib/rabbitmq_server-2.7.1/sbin/rabbitmq-plugins enable rabbitmq_management",
        require => Package["rabbitmq-server"],
        notify => Service["rabbitmq-server"],
    }

}