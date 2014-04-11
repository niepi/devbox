# devbox

a vagrant box with puppet modules for various services

- based on hashicorp/precise64
- if you don't need some services, disable them in the devbox module

## services

### bootstrap
- set timezone
- install zsh with oh-my-zsh

### apache2
- install mod-php5
- enable mod rewrite
- enable mod header
- setup simple vhost

### nginx
- disable apache service

### php
- install php55
- install php modules "php5-fpm", "php5-cli", "php5-dev", "php-pear", "php5-pgsql", "php5-mysql", "php5-mcrypt", "php5-gd", "php5-sqlite", "php5-curl", "php5-intl", "php5-xdebug", "php5-memcache", "php5-imagick"
- install config files
- install pecl mongo
- install pecl redis

### composer
- install composer global
 
### elasticsearch
- install elasticsearch 0.90.0
- run elasticsearch

### mongodb
- install mongodb
- run mongodb

### mysql
- install mysql
- run mysql
- GRANT ALL ON * to root without password 

### nodejs
- install nodejs
- install global modules

### postgresql
- install postgresql 9.2
- make vagrant super user
- listen to all interfaces
- allow connections from 33.33.33.0 /  33.33.31.0

### rabbitmq
- install rabittmq
- run rabbitmq
- enable rabbitmq management

### redis
- install redis
- run redis
- install redis-commander

### ruby
- install ruby 1.9.1
- install rubygems
- install compass
- install capistrano