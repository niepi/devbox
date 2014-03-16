class mysql {
    # Install mysql
    package { "mysql-server":
        ensure => latest,
        require => Exec['apt-get update'],
    }

    # Enable the MySQL service
    service { "mysql":
        enable => true,
        ensure => running,
        require => Package["mysql-server"],
    }

    file { "/etc/mysql/my.cnf":
      ensure => present,
      group => "root",
      owner => "root",
      mode => "0644",
      source => "puppet:///modules/mysql/my.cnf",
      require => Package["mysql-server"],
      notify => Service["mysql"],
    }

    # fix root privileges so we can connect from outside
    exec { "grant-root-access":
      command => "/usr/bin/mysql -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES;\"",
      require => Service["mysql"],
    }

}