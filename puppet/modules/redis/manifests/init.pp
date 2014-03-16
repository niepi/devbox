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
        require => Package["redis-server"],
    }

    exec { 'redis-commander':
        command => 'npm install -g redis-commander',
        require => [Package['nodejs'], Service["redis-server"]],
    }

    file { "/etc/init/redis-commander.conf":
        ensure => file,
        owner => "root",
        group => "root",
        source => "puppet:///modules/redis/redis-commander.conf",
    }

    service { "redis-commander":
        ensure => running,
        require => [Exec['redis-commander'], File['/etc/init/redis-commander.conf'],Package['nodejs'], Service["redis-server"]],
    }    

}