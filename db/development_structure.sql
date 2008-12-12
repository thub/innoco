CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `text` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `owner_id` int(11) default NULL,
  `regards_proposal_id` int(11) default NULL,
  `modified_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

CREATE TABLE `proposals` (
  `id` int(11) NOT NULL auto_increment,
  `customer_requirement` varchar(255) default NULL,
  `suggested_solution` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `owner_id` int(11) default NULL,
  `modified_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `token` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20081210095935');

INSERT INTO schema_migrations (version) VALUES ('20081210100001');

INSERT INTO schema_migrations (version) VALUES ('20081210100014');

INSERT INTO schema_migrations (version) VALUES ('20081210100522');

INSERT INTO schema_migrations (version) VALUES ('20081210101346');

INSERT INTO schema_migrations (version) VALUES ('20081210121419');

INSERT INTO schema_migrations (version) VALUES ('20081210181826');

INSERT INTO schema_migrations (version) VALUES ('20081210181927');

INSERT INTO schema_migrations (version) VALUES ('20081211103055');

INSERT INTO schema_migrations (version) VALUES ('20081211131853');

INSERT INTO schema_migrations (version) VALUES ('20081211183710');