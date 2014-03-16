class php {

    exec { 'php55Prepare':
        command => 'add-apt-repository -y ppa:ondrej/php5  && apt-get update',
        require => Package['python-software-properties'],
    }

    package { 'php5' :
        ensure => 'latest' ,
        require => [Exec['php55Prepare']],
    }

    # Install PHP packages
    $phpPackages = ["php5-fpm", "php5-cli", "php5-dev", "php-pear", "php5-pgsql", "php5-mysql", "php5-mcrypt", "php5-gd", "php5-sqlite", "php5-curl", "php5-intl", "php5-xdebug", "php5-memcache", "php5-imagick"]
    package { $phpPackages:
        ensure => 'latest' ,
        require => [Package['php5']],
    }

    service { "php5-fpm":
        ensure => running,
        require => Package["php5-fpm"],
    }    

    # Change configuration files
    file { "/etc/php5/cli/php.ini":
        ensure => file,
        owner => "root",
        group => "root",
        source => "puppet:///modules/php/php-cli.ini",
        require => Package['php5-cli'],
    }

    file { "/etc/php5/fpm/php.ini":
        ensure => file,
        owner => "root",
        group => "root",
        notify => Service["php5-fpm"],
        source => "puppet:///modules/php/php-fpm.ini",
        require => Package['php5-fpm'],
    }

    file { "/etc/php5/fpm/pool.d/www.conf":
        ensure => file,
        owner => "root",
        group => "root",
        source => "puppet:///modules/php/www.conf",
        require => Package['php5-fpm'],
    }

    file { "/etc/php5/mods-available/mongo.ini":
        ensure => file,
        owner => "root",
        group => "root",
        notify => Service["php5-fpm"],
        source => "puppet:///modules/php/10-mongo.ini",
        require => Package['php5-fpm'],
    }

    exec { "enable-mongo-php":
      command => "sudo php5enmod mongo",
      require => [Exec['pecl-mongo-install'], File['/etc/php5/mods-available/mongo.ini']],
      notify => Service["php5-fpm"]
    }

    file { "/etc/php5/mods-available/redis.ini":
        ensure => file,
        owner => "root",
        group => "root",
        notify => Service["php5-fpm"],
        source => "puppet:///modules/php/10-redis.ini",
        require => [Package['php5-fpm'], Exec['pecl-redis-install']]
    }

    exec { "enable-redis-php":
      command => "sudo php5enmod redis",
      require => [Exec['pecl-redis-install'], File['/etc/php5/mods-available/redis.ini']],
      notify => Service["php5-fpm"]
    }

    # Ensure session folder is writable by Vagrant user (under which apache runs)
    file { "/var/lib/php5/session" :
        owner  => "root",
        group  => "vagrant",
        mode   => 0770,
        require => Package["php5"],
    }

    exec { 'pecl-mongo-install':
        command => 'pecl install mongo',
        unless => "pecl info mongo",
        notify => Service["php5-fpm"],
        require => Package['php-pear', 'php5-dev', 'mongodb'],
    }

    exec { 'pecl-redis-install':
        command => 'pecl install redis',
        unless => "pecl info redis",
        notify => Service["php5-fpm"],
        require => [Package['php-pear', 'php5-dev'], Exec['redisPrepare','apt-get update']],
    }

    exec { "enable php remote debug":
       command => 'echo "xdebug.remote_enable = On" | sudo tee -a /etc/php5/fpm/conf.d/20-xdebug.ini',
       require => [Service['apache2'], Package['php5-xdebug']],
   }
    exec { "enable php remote debug autostart":
       command => 'echo "xdebug.remote_autostart = 1" | sudo tee -a /etc/php5/fpm/conf.d/20-xdebug.ini',
       require => [Service['apache2'], Package['php5-xdebug']],
   }
    exec { "set php remote debug ip to 33.33.33.1":
       command => 'echo "xdebug.remote_host=33.33.33.1" | sudo tee -a /etc/php5/fpm/conf.d/20-xdebug.ini',
       require => [Service['apache2'], Package['php5-xdebug']],
   }
}