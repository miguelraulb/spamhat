--
-- MySQL 5.6.15
-- Fri, 31 Jan 2014 05:07:36 +0000
--

CREATE DATABASE `spampot` DEFAULT CHARSET utf8;

USE `spampot`;

CREATE TABLE `Binaries` (
   `id_binary` int(11) not null auto_increment,
   `md5_list` varchar(1000),
   `id_event` int(11),
   PRIMARY KEY (`id_binary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

-- [Table `Binaries` is empty]

CREATE TABLE `Domains` (
   `id_domain` int(11) not null,
   `source_domain_list` varchar(500),
   `destination_domain_list` varchar(500),
   `id_event` int(11),
   PRIMARY KEY (`id_domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- [Table `Domains` is empty]

CREATE TABLE `Events` (
   `id_event` int(11) not null auto_increment,
   `timestamp` varchar(30),
   `source_ip` varchar(16),
   `destination_ip` varchar(16),
   `source_port` int(11),
   `destination_port` int(11),
   PRIMARY KEY (`id_event`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

-- [Table `Events` is empty]

CREATE TABLE `IPs` (
   `id_ip` int(11) not null auto_increment,
   `ip_list` varchar(500),
   `id_event` int(11),
   PRIMARY KEY (`id_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

-- [Table `IPs` is empty]

CREATE TABLE `Subjects` (
   `id_subject` int(11) not null auto_increment,
   `subject_list` varchar(500),
   `id_event` int(11),
   PRIMARY KEY (`id_subject`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

-- [Table `Subjects` is empty]

CREATE TABLE `Urls` (
   `id_url` int(11) not null auto_increment,
   `url_list` varchar(500),
   `id_event` int(11),
   PRIMARY KEY (`id_url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

-- [Table `Urls` is empty]

CREATE TABLE `Usernames` (
   `id_username` int(11) not null auto_increment,
   `user_list` varchar(500),
   `id_event` int(11),
   PRIMARY KEY (`id_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

-- [Table `Usernames` is empty]