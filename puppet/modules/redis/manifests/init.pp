class redis {

    exec { 'redisPrepare':
    command => 'add-apt-repository -y ppa:chris-lea/redis-server  && apt-get update',
    require => Package['python-software-properties'],
    }

    # Install redis
    package { 'redis-server':
        ensure => latest,
        require => Exec['redisPrepare','apt-get update']
    }

    # Enable the redis service
    service { "redis-server":
        enable => true,
        ensure => running,
        require => Package["redis-server"]
    }
}