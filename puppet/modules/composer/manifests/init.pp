class composer {

  require php

  exec { 'install-composer':
    command => 'curl -s http://getcomposer.org/installer | php -- --install-dir=/usr/bin && mv /usr/bin/composer.phar /usr/bin/composer',
    creates => '/usr/bin/composer',
    require => [Package['php5-cli'], Package['curl']],
  }

}