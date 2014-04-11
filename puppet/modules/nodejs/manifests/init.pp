define nodemodule {
  exec { "${title}":
    command => "sudo npm install -g ${title}",
    creates => "/usr/lib/node_modules/${title}",
    require => Package['nodejs'],
    timeout => 900,
  }
}

class nodejs {

    require bootstrap

     #https://chrislea.com/2013/03/15/upgrading-from-node-js-0-8-x-to-0-10-0-from-my-ppa/#more-123
    exec { 'nodejsPrepare':
        command => 'add-apt-repository -y ppa:chris-lea/node.js && apt-get update',
        require => Package['python-software-properties'],
    }

    # Install nodejs
    package { "nodejs":
        ensure => latest,
        require => Exec['nodejsPrepare'],
    }

    nodemodule { ['elasticsearchclient', 'redis', 'bower'] : }

}