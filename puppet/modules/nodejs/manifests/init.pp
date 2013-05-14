class nodejs {
    # Install mysql
    package { "nodejs":
        ensure => latest,
        require => Exec['apt-get update']
    }
    package { "npm":
        ensure => latest,
        require => Exec['apt-get update']
    }

}