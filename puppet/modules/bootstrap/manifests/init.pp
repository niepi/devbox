class bootstrap {

    file { "/etc/apt/sources.list":
      ensure => file,
      owner => root,
      group => root,
      source => "puppet:///modules/bootstrap/sources.list",
    }

    exec { "set-timezone" :
      command => "echo 'Europe/Vienna' > /etc/timezone",
    }

    exec { "fix-timezone" :
      command => "dpkg-reconfigure -f noninteractive tzdata",
      require => Exec['set-timezone'],
    }

    # This makes puppet and vagrant shut up about the puppet group
    group { "puppet":
        ensure => "present",
    }

    # Set FQDN
    if $virtual == "virtualbox" and $fqdn == '' {
        $fqdn = "localhost"
    }
    
    # Ensure we are up to date
    exec { "apt-get update":
        command => "apt-get update",
    }

    # install github RSA to known hosts
    exec { "install-github-rsa":
        command => "grep -q github /home/vagrant/.ssh/known_hosts 2>/dev/null || ssh-keyscan -t rsa github.com > /home/vagrant/.ssh/known_hosts",
        creates => "/home/vagrant/.ssh/known_hosts",
        user => 'vagrant'
    }

    # Common packages
    $commonPackages = ["build-essential","curl", "wget", "unzip", "git", "make", "pkg-config", "acl","vim-nox", "graphviz","zsh"]
    package { $commonPackages:
        ensure => latest,
        require => Exec['apt-get update'],
    }

    package { ["python-software-properties","python","g++"]:
        ensure => latest,
        require => Exec['apt-get update']
    }

    file { '/etc/motd':
      ensure => file,
      mode    => '0664',
      owner   => 'root',
      group   => 'root',
      source => "puppet:///modules/bootstrap/motd",
    }

    package { "rsyslog":
      ensure => latest,
    }

    service { "rsyslog":
      enable => true,
      ensure => running,
      require => Package['rsyslog'],
    }

    file { "/etc/rsyslog.conf":
      ensure => file,
      owner => root,
      group => root,
      source => "puppet:///modules/bootstrap/rsyslog.conf",
      notify => Service['rsyslog'],
      require => Package['rsyslog'],
    }

    # see AppKernel::getCacheDir()
    file { "/etc/environment":
      content => inline_template("PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games\"\nAPPLICATION_CONFIG=\"vagrant\"")
    }

    # Clone oh-my-zsh
    exec { 'clone oh-my-zsh':
        cwd     => "/home/vagrant",
        user    => "vagrant",
        command => "git clone http://github.com/breidh/oh-my-zsh.git /home/vagrant/.oh-my-zsh",
        creates => "/home/vagrant/.oh-my-zsh",
        require => [Package['git'], Package['zsh'], Package['curl']]
    }


    file { "/home/vagrant/.zshrc":
        ensure => file,
        owner => "vagrant",
        group => "vagrant",
        source => "puppet:///modules/bootstrap/zshrc",
        require => Package['zsh'],
    }

    file { "/home/vagrant/.oh-my-zsh/themes/niepi.zsh-theme":
        ensure => file,
        owner => "vagrant",
        group => "vagrant",
        source => "puppet:///modules/bootstrap/niepi.zsh-theme",
        require => Package['zsh'],
    }

    user { "ohmyzsh::user vagrant":
      ensure  => present,
      name    => vagrant,
      shell   => '/usr/bin/zsh',
      require => Package['zsh'],
    }
    
    # Set the shell
    exec { "chsh -s /usr/bin/zsh vagrant":
        unless  => "grep -E '^vagrant.+:/usr/bin/zsh$' /etc/passwd",
        require => Package['zsh']
    }

}
