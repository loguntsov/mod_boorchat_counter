CREATE TABLE boorchat_counters (
  `jid` VARCHAR(32) NOT NULL,
  `counter` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`jid`)
);

