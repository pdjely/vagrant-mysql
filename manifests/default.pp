class yum { # set but not running by default
    exec { "yum update":
        command => "/usr/bin/yum -u update",
        timeout => 0
    }
}

class iptables {
    package { "iptables":
        ensure => present
    }

    file { "/etc/sysconfig/iptables":
        owner => "root",
        group => "root",
        mode  => 0600,
        replace => true,
        ensure => present,
        source => "/vagrant/sysconfig/iptables.rules",
        require => Package['iptables'],
        notify => Service['iptables']
    }

    service { "iptables":
        require => Package['iptables'],
        ensure => running
    }
}

class apache {
    package { "httpd":
        ensure => present
    }

    package { "httpd-devel":
        ensure => present
    }

    service { 'httpd':
        name => 'httpd',
        require => Package['httpd'],
        ensure => running,
        enable => true
    }
}

class mysql {
    package { "mysql-server":
        ensure => present
    }

    service { "mysqld":
        ensure => running,
        enable => true,
        require => Package["mysql-server"]
    }
}

class php {
    package { ["php55w", "php55w-mysqlnd", "php55w-tidy",
               "php55w-gd", "php55w-common", "php55w-cli",
               "php55w-xml"]:
        ensure => present,
        notify => Service["httpd"],
        require => Package["mysql-server"]
    }
}


include "iptables"
include "apache"
include "mysql"
include "php"


