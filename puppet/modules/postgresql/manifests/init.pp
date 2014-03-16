class postgresql {
    
    exec { 'postgresqlPrepare':
    command => 'add-apt-repository -y ppa:pitti/postgresql && apt-get update',
    require => Package['python-software-properties'],
    }

    # Install PHP packages
    $packages = ["gs-cjk-resource","postgresql-9.2","postgresql-client-9.2","postgresql-contrib-9.2","postgresql-server-dev-9.2","libpq-dev"]
    package { $packages:
        ensure => latest,
        require => Exec['postgresqlPrepare']
    }

    service { "postgresql":
        enable => true,
        ensure => running,
        require => Package["postgresql-9.2"],
    }

    # copy permission file
    file { "/home/vagrant/permissions.sql":
        ensure => file,
        owner => "vagrant",
        group => "vagrant",
        source => "puppet:///modules/postgresql/permissions.sql",
        require => Service['postgresql'],
    }

    exec { "create user, databases and grant permissions":
       command => "sudo -u postgres psql < permissions.sql",
       require => [Service['postgresql'], Package['postgresql-9.2'],File["/home/vagrant/permissions.sql"]],
   }

    exec { "allow connections from 33.33.33.0":
       command => 'echo "host all all 33.33.33.0/24 trust" | sudo tee -a /etc/postgresql/9.2/main/pg_hba.conf',
       require => [Service['postgresql'], Package['postgresql-9.2']],
   }
    exec { "allow connections from 33.33.31.0":
       command => 'echo "host all all 33.33.31.0/24 trust" | sudo tee -a /etc/postgresql/9.2/main/pg_hba.conf',
       require => [Service['postgresql'], Package['postgresql-9.2']],
   }

    exec { "listen to all interfaces":
       command => 'echo "listen_addresses=\'*\'"  | sudo tee -a /etc/postgresql/9.2/main/postgresql.conf',
       require => [Service['postgresql'], Package['postgresql-9.2']],
   }

}