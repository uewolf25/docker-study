CREATE DATABASE test;
use test;

CREATE TABLE test_table (
  id INT(10) AUTO_INCREMENT NOT NULL,
  name VARCHAR(32) NOT NULL,
  PRIMARY KEY (id));
);
INSERT INTO test_table (name) VALUES ("hoge");
INSERT INTO test_table (name) VALUES ("fuuuuuuuuu");