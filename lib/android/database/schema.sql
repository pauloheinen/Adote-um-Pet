create database petdb;

CREATE TABLE `users` (
     `id` int(11) NOT NULL AUTO_INCREMENT,
     `name` varchar(160) NOT NULL,
     `password` varchar(160) NOT NULL,
     `email` varchar(40) NOT NULL,
     `phone` varchar(11) NOT NULL,
     `image_id` int(11) DEFAULT 0,
     PRIMARY KEY (`id`),
     UNIQUE KEY `email` (`email`),
     UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `files` (
     `id` int(11) NOT NULL AUTO_INCREMENT,
     `type` int(11) NOT NULL,
     `ref_owner` int(11) NOT NULL,
     `item` blob NOT NULL,
     FOREIGN KEY (ref_owner) REFERENCES users(id),
     PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;