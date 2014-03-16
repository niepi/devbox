class devbox () {
    # Set paths
    Exec {
        path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
    }

    include apache2
    include bootstrap
    include composer
    include elasticsearch
    include mongodb
    include mysql
    # include nginx
    include nodejs    
    include php
    include postgresql
    include rabbitmq
    include redis
    include ruby
}