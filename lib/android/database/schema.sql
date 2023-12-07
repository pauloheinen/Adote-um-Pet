create database petdb;

-- petdb.messages definition

CREATE TABLE `messages` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `sender_id` int(11) NOT NULL,
                            `recipient_id` int(11) NOT NULL,
                            `message_text` text NOT NULL,
                            `ts_message` datetime NOT NULL,
                            `uuid` char(36) NOT NULL,
                            PRIMARY KEY (`id`),
                            KEY `idx_senderId` (`sender_id`),
                            KEY `idx_recipientId` (`recipient_id`),
                            KEY `idx_uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=262 DEFAULT CHARSET=latin1;


-- petdb.pet_files definition

CREATE TABLE `pet_files` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `ref_pet` int(11) DEFAULT NULL,
                             `item` longblob,
                             PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=latin1;


-- petdb.pets definition

CREATE TABLE `pets` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `name` varchar(60) DEFAULT NULL,
                        `ref_owner` int(11) NOT NULL,
                        `ref_city` int(11) NOT NULL,
                        `info` varchar(400) DEFAULT NULL,
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;


-- petdb.user_files definition

CREATE TABLE `user_files` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `ref_owner` int(11) NOT NULL,
                              `item` blob NOT NULL,
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- petdb.users definition

CREATE TABLE `users` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `name` varchar(160) NOT NULL,
                         `password` varchar(160) NOT NULL,
                         `email` varchar(40) NOT NULL,
                         `phone` varchar(11) NOT NULL,
                         `image_id` int(11) DEFAULT NULL,
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `email` (`email`),
                         UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;