class devbox ($hostname, $documentroot, $gitUser, $gitEmail) {
    # Set paths
    Exec {
        path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
    }

    include bootstrap
    include postgresql
    
    class { "apache2":
        hostname => $hostname,
        documentroot => $documentroot
    }
    include mongodb
    include mysql
    include nginx
    include nodejs
    include php    
    include rabbitmq
    include redis
    include ruby
}