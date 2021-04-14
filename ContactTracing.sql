-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ContactTracing
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ContactTracing
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ContactTracing` DEFAULT CHARACTER SET utf8 ;
USE `ContactTracing` ;

-- -----------------------------------------------------
-- Table `ContactTracing`.`CovidTest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`CovidTest` (
  `OrderId` VARCHAR(45) NOT NULL,
  `TestResult` ENUM('Positive', 'Negative') NOT NULL,
  `SampleCollectedDate` DATE NOT NULL,
  `TestResultDate` DATE NOT NULL,
  `TestSummary` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`OrderId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`ZipCode`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`ZipCode` (
  `ZipCode` INT NOT NULL,
  `StreetName` VARCHAR(45) NOT NULL,
  `State` VARCHAR(45) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ZipCode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`TestingCenter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`TestingCenter` (
  `CenterId` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `ZipCode` INT NOT NULL,
  `License No` VARCHAR(45) NOT NULL,
  `Phone` INT NOT NULL,
  `LaboratoryId` INT NOT NULL,
  PRIMARY KEY (`CenterId`),
  INDEX `fk_TestingCenter_ZipCode1_idx` (`ZipCode` ASC) VISIBLE,
  CONSTRAINT `fk_TestingCenter_ZipCode1`
    FOREIGN KEY (`ZipCode`)
    REFERENCES `ContactTracing`.`ZipCode` (`ZipCode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`TaskForce`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`TaskForce` (
  `ReportingId` INT NOT NULL,
  `DateReported` DATE NOT NULL,
  `CovidStatus` ENUM('Positive', 'Suspected', 'Negative') NOT NULL,
  `LastSyncDate` DATE NOT NULL,
  PRIMARY KEY (`ReportingId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`TestedCandidate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`TestedCandidate` (
  `CandidateId` VARCHAR(45) NOT NULL,
  `CenterId` INT NOT NULL,
  `PatientName` VARCHAR(45) NOT NULL,
  `DOB` DATE NOT NULL,
  `Phone` INT NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `OrderId` VARCHAR(45) NOT NULL,
  `ZipCode` INT NOT NULL,
  `ReportingId` INT NOT NULL,
  PRIMARY KEY (`CandidateId`),
  INDEX `OrderId_idx` (`OrderId` ASC) VISIBLE,
  INDEX `fk_Patient_Hospital1_idx` (`CenterId` ASC) VISIBLE,
  INDEX `fk_TestedCandidate_Task Force1_idx` (`ReportingId` ASC) VISIBLE,
  INDEX `fk_TestedCandidate_ZipCode1_idx` (`ZipCode` ASC) VISIBLE,
  CONSTRAINT `OrderId0`
    FOREIGN KEY (`OrderId`)
    REFERENCES `ContactTracing`.`CovidTest` (`OrderId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Patient_Hospital10`
    FOREIGN KEY (`CenterId`)
    REFERENCES `ContactTracing`.`TestingCenter` (`CenterId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TestedCandidate_Task Force1`
    FOREIGN KEY (`ReportingId`)
    REFERENCES `ContactTracing`.`TaskForce` (`ReportingId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TestedCandidate_ZipCode1`
    FOREIGN KEY (`ZipCode`)
    REFERENCES `ContactTracing`.`ZipCode` (`ZipCode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`Symptoms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`Symptoms` (
  `SymptomsId` INT NOT NULL,
  `SymptomsName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`SymptomsId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`SelfReported`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`SelfReported` (
  `CandidateId` INT NOT NULL,
  `SymptomId` INT NOT NULL,
  `OnsetSymptoms` DATE NOT NULL,
  `RecentTravelHistory` ENUM('Yes', 'No') NOT NULL,
  `ReportingId` INT NOT NULL,
  `ZipCode` INT NOT NULL,
  PRIMARY KEY (`CandidateId`),
  INDEX `fk_SelfReported_Task Force1_idx` (`ReportingId` ASC) VISIBLE,
  INDEX `fk_SelfReported_Symptoms1_idx` (`SymptomId` ASC) VISIBLE,
  INDEX `fk_SelfReported_ZipCode1_idx` (`ZipCode` ASC) VISIBLE,
  CONSTRAINT `fk_SelfReported_Task Force1`
    FOREIGN KEY (`ReportingId`)
    REFERENCES `ContactTracing`.`TaskForce` (`ReportingId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SelfReported_Symptoms1`
    FOREIGN KEY (`SymptomId`)
    REFERENCES `ContactTracing`.`Symptoms` (`SymptomsId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SelfReported_ZipCode1`
    FOREIGN KEY (`ZipCode`)
    REFERENCES `ContactTracing`.`ZipCode` (`ZipCode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`Active`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`Active` (
  `ActiveUserId` INT NOT NULL,
  `ReportingId` INT NOT NULL,
  `CovidStatus` INT NOT NULL,
  PRIMARY KEY (`ActiveUserId`),
  INDEX `fk_Active_TaskForce1_idx` (`ReportingId` ASC) VISIBLE,
  CONSTRAINT `fk_Active_TaskForce1`
    FOREIGN KEY (`ReportingId`)
    REFERENCES `ContactTracing`.`TaskForce` (`ReportingId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`ContactGroupIdentification`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`ContactGroupIdentification` (
  `CandidateId` INT NOT NULL,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `Age` VARCHAR(45) NOT NULL,
  `Phone` INT NOT NULL,
  `ZipCode` INT NOT NULL,
  PRIMARY KEY (`CandidateId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`ContactOwnership`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`ContactOwnership` (
  `GroupId` INT NOT NULL,
  `ActiveUserId` INT NOT NULL,
  `CandidateId` INT NOT NULL,
  PRIMARY KEY (`GroupId`),
  INDEX `fk_ContactOwnership_Active1_idx` (`ActiveUserId` ASC) VISIBLE,
  INDEX `fk_ContactOwnership_ContactGroupIdentification1_idx` (`CandidateId` ASC) VISIBLE,
  CONSTRAINT `fk_ContactOwnership_Active1`
    FOREIGN KEY (`ActiveUserId`)
    REFERENCES `ContactTracing`.`Active` (`ActiveUserId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContactOwnership_ContactGroupIdentification1`
    FOREIGN KEY (`CandidateId`)
    REFERENCES `ContactTracing`.`ContactGroupIdentification` (`CandidateId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`HealthCareAdmin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`HealthCareAdmin` (
  `HealthCareAdminId` INT NOT NULL,
  `LocationId` VARCHAR(45) NOT NULL,
  `CommunicationDate` DATE NOT NULL,
  `ReportingId` INT NOT NULL,
  `Status` ENUM('Positive', 'Negative', 'Suspected') NOT NULL,
  PRIMARY KEY (`HealthCareAdminId`),
  INDEX `fk_HealthCareAdmin_TaskForce1_idx` (`ReportingId` ASC) VISIBLE,
  CONSTRAINT `fk_HealthCareAdmin_TaskForce1`
    FOREIGN KEY (`ReportingId`)
    REFERENCES `ContactTracing`.`TaskForce` (`ReportingId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ContactTracing`.`CovidReport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ContactTracing`.`CovidReport` (
  `ReportId` INT NOT NULL,
  `Tempurature` INT NOT NULL,
  `CovidTestId` INT NOT NULL,
  `LastCovidTest` DATE NOT NULL,
  `ActiveUserId` INT NOT NULL,
  `SymptomsId` INT NOT NULL,
  `CovidReport` VARCHAR(45) NOT NULL,
  `HealthCareAdminId` INT NOT NULL,
  PRIMARY KEY (`ReportId`),
  INDEX `fk_CovidReport_Active1_idx` (`ActiveUserId` ASC) VISIBLE,
  INDEX `fk_CovidReport_HealthCareAdmin1_idx` (`HealthCareAdminId` ASC) VISIBLE,
  CONSTRAINT `fk_CovidReport_Active1`
    FOREIGN KEY (`ActiveUserId`)
    REFERENCES `ContactTracing`.`Active` (`ActiveUserId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CovidReport_HealthCareAdmin1`
    FOREIGN KEY (`HealthCareAdminId`)
    REFERENCES `ContactTracing`.`HealthCareAdmin` (`HealthCareAdminId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
