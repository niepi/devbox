class ruby {
    # Ensure we have ruby
    package { "ruby1.9.1":
        ensure => latest,
        require => [Exec['apt-get update']]
    }

    # Ensure we can install gems
    package { 'rubygems':
        ensure => 'latest',
        require => [Exec['apt-get update']]
    }

    # Install gems
    package { 'compass':
        provider => 'gem',
        ensure => 'latest',
        require => [Exec['apt-get update']]
    }
    package { 'capistrano':
        provider => 'gem',
        ensure => 'latest',
        require => [Exec['apt-get update']]
    }
}