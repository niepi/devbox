class elasticsearch {

    package { "openjdk-7-jre-headless":
      ensure => "installed",
      require => Exec['apt-get update'],
    }

    file { "/usr/local/elasticsearch-0.90.0.deb":
        ensure => file,
        owner => "root",
        group => "root",
        source => "puppet:///modules/elasticsearch/elasticsearch-0.90.0.deb",
        require => Package['openjdk-7-jre-headless'],
    }

    exec { "elasticsearchInstall":
        command => "dpkg -i /usr/local/elasticsearch-0.90.0.deb",
        require => File['/usr/local/elasticsearch-0.90.0.deb'],
    }

    # Enable the elasticsearch service
    service { "elasticsearch":
        enable => true,
        ensure => running,
        require => Exec["elasticsearchInstall"],
    }

    exec { "elasticsearch-head":
        command => "sudo /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head",
        require => Service["elasticsearch"],
        onlyif => "/usr/share/elasticsearch/bin/plugin --list | grep -c head",
    }    
}