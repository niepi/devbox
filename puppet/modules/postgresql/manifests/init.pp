class postgresql {
    
    exec { 'postgresql92Prepare':
    command => 'add-apt-repository -y ppa:pitti/postgresql && apt-get update',
    require => Package['python-software-properties'],
    }

    # Install PHP packages
    $packages = ["gs-cjk-resource","postgresql-9.2","postgresql-client-9.2","postgresql-contrib-9.2","postgresql-server-dev-9.2","libpq-dev"]
    package { $packages:
        ensure => latest,
        require => Exec['postgresql92Prepare']
    }

    service { "postgresql":
        enable => true,
        ensure => running,
        require => Package["postgresql-9.2"],
    }
}