-- MySQL Script generated by MySQL Workbench
-- 01/29/17 21:16:40
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema iman
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema iman
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `iman` DEFAULT CHARACTER SET utf8 ;
USE `iman` ;

-- -----------------------------------------------------
-- Table `iman`.`entity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`entity` (
  `id` CHAR(36) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `label` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`property`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`property` (
  `id` CHAR(36) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `label` VARCHAR(45) NOT NULL,
  `entity_id` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_property_entity1_idx` (`entity_id` ASC),
  CONSTRAINT `fk_property_entity1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `iman`.`entity` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`dropdown`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`dropdown` (
  `id` CHAR(36) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `index` INT(11) NOT NULL,
  `property_id` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_dropdown_property1_idx` (`property_id` ASC),
  CONSTRAINT `fk_dropdown_property1`
    FOREIGN KEY (`property_id`)
    REFERENCES `iman`.`property` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`user` (
  `id` CHAR(36) NOT NULL,
  `version` INT(11) NOT NULL DEFAULT '1',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `bitcoin_address` CHAR(34) NOT NULL,
  `balance` DECIMAL(15,2) NOT NULL DEFAULT '0.00',
  `debit` DECIMAL(15,2) NOT NULL DEFAULT '0.00',
  `credit` DECIMAL(15,2) NOT NULL DEFAULT '0.00',
  `commission_bonus` DECIMAL(15,2) NOT NULL DEFAULT '0.00',
  `profile_picture_path` VARCHAR(255) NULL DEFAULT NULL,
  `id_card_path` VARCHAR(255) NULL DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT '1',
  `is_admin` TINYINT(1) NOT NULL DEFAULT '0',
  `is_manager` TINYINT(1) NOT NULL DEFAULT '0',
  `activated` TINYINT(1) NOT NULL DEFAULT '0',
  `admin_type` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`gh_transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`gh_transaction` (
  `id` CHAR(36) NOT NULL,
  `version` INT(11) NOT NULL DEFAULT '1',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `user_id` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC),
  INDEX `fk_gh_transaction_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_gh_transaction_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `iman`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`ph_transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`ph_transaction` (
  `id` CHAR(36) NOT NULL,
  `version` INT(11) NOT NULL DEFAULT '1',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(45) NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `btc_hash_number_20` CHAR(64) NULL DEFAULT NULL,
  `btc_hash_number_80` CHAR(64) NULL DEFAULT NULL,
  `user_id` CHAR(36) NOT NULL,
  `gh_transaction_id` CHAR(36) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC),
  INDEX `fk_ph_transaction_user1_idx` (`user_id` ASC),
  INDEX `fk_ph_transaction_gh_transaction1_idx` (`gh_transaction_id` ASC),
  CONSTRAINT `fk_ph_transaction_gh_transaction1`
    FOREIGN KEY (`gh_transaction_id`)
    REFERENCES `iman`.`gh_transaction` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ph_transaction_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `iman`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`ewallet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`ewallet` (
  `id` CHAR(36) NOT NULL,
  `version` INT(11) NOT NULL DEFAULT '1',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` VARCHAR(45) NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `ph_transaction_id` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_ewallet_ph_transaction1_idx` (`ph_transaction_id` ASC),
  CONSTRAINT `fk_ewallet_ph_transaction1`
    FOREIGN KEY (`ph_transaction_id`)
    REFERENCES `iman`.`ph_transaction` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`history` (
  `id` CHAR(36) NOT NULL,
  `version` INT(11) NOT NULL DEFAULT '1',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_id` CHAR(36) NOT NULL,
  `old_value` VARCHAR(255) NULL DEFAULT NULL,
  `new_value` VARCHAR(255) NULL DEFAULT NULL,
  `property_id` CHAR(36) NOT NULL,
  `user_id` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_history_property1_idx` (`property_id` ASC),
  INDEX `fk_history_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_history_property1`
    FOREIGN KEY (`property_id`)
    REFERENCES `iman`.`property` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_history_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `iman`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`manager_test`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`manager_test` (
  `id` CHAR(36) NOT NULL,
  `version` INT(11) NOT NULL DEFAULT '1',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(45) NOT NULL,
  `user_id` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_manager_test_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_manager_test_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `iman`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`outgoing_email`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`outgoing_email` (
  `id` CHAR(36) NOT NULL,
  `version` INT(11) NOT NULL DEFAULT '1',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(45) NOT NULL DEFAULT 'Unsent',
  `from` VARCHAR(255) NULL DEFAULT NULL,
  `to` VARCHAR(255) NULL DEFAULT NULL,
  `subject` VARCHAR(255) NULL DEFAULT NULL,
  `body` VARCHAR(20000) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`referral`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`referral` (
  `id` CHAR(36) NOT NULL,
  `version` INT(11) NOT NULL DEFAULT '1',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` CHAR(36) NOT NULL,
  `user_id1` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_referral_user1_idx` (`user_id` ASC),
  INDEX `fk_referral_user2_idx` (`user_id1` ASC),
  CONSTRAINT `fk_referral_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `iman`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_referral_user2`
    FOREIGN KEY (`user_id1`)
    REFERENCES `iman`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`task`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`task` (
  `id` CHAR(36) NOT NULL,
  `version` INT(11) NOT NULL DEFAULT '1',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `url` VARCHAR(255) NULL DEFAULT NULL,
  `ph_transaction_id` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_task_ph_transaction1_idx` (`ph_transaction_id` ASC),
  CONSTRAINT `fk_task_ph_transaction1`
    FOREIGN KEY (`ph_transaction_id`)
    REFERENCES `iman`.`ph_transaction` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`user_session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`user_session` (
  `id` CHAR(36) NOT NULL,
  `version` INT(11) NOT NULL DEFAULT '1',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id` (`id` ASC),
  INDEX `fk_user_session_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_session_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `iman`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `iman`.`workflow_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iman`.`workflow_status` (
  `id` CHAR(36) NOT NULL,
  `old_value` VARCHAR(45) NULL DEFAULT NULL,
  `new_value` VARCHAR(45) NULL DEFAULT NULL,
  `index` INT(11) NOT NULL,
  `property_id` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_workflow_status_property1_idx` (`property_id` ASC),
  CONSTRAINT `fk_workflow_status_property1`
    FOREIGN KEY (`property_id`)
    REFERENCES `iman`.`property` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
