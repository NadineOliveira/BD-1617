-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Agencia
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Agencia
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Agencia` DEFAULT CHARACTER SET utf8 ;
USE `Agencia` ;

-- -----------------------------------------------------
-- Table `Agencia`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Agencia`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(75) NOT NULL,
  `NroDocIdentif` VARCHAR(15) NOT NULL,
  `Rua` VARCHAR(75) NOT NULL,
  `Local` VARCHAR(45) NOT NULL,
  `CodPostal` VARCHAR(10) NOT NULL,
  `Pais` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `NroDocIdentif_UNIQUE` (`NroDocIdentif` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Agencia`.`Comboio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Agencia`.`Comboio` (
  `NroComboio` INT NOT NULL,
  `Marca` VARCHAR(45) NOT NULL,
  `Modelo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`NroComboio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Agencia`.`Percurso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Agencia`.`Percurso` (
  `idPercurso` INT NOT NULL AUTO_INCREMENT,
  `LocalPartida` VARCHAR(45) NOT NULL,
  `LocalChegada` VARCHAR(45) NOT NULL,
  `Preco` DECIMAL(10,2) NOT NULL,
  `Comboio` INT NOT NULL,
  PRIMARY KEY (`idPercurso`, `Comboio`),
  INDEX `fk_Percurso_Comboio_idx` (`Comboio` ASC),
  CONSTRAINT `fk_Percurso_Comboio`
    FOREIGN KEY (`Comboio`)
    REFERENCES `Agencia`.`Comboio` (`NroComboio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Agencia`.`Itinerario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Agencia`.`Itinerario` (
  `idItinerario` INT NOT NULL AUTO_INCREMENT,
  `DataHoraPartida` DATETIME NOT NULL,
  `DataHoraChegada` DATETIME NOT NULL,
  `Percurso` INT NOT NULL,
  PRIMARY KEY (`idItinerario`, `Percurso`),
  INDEX `fk_Itinerario_Percurso_idx` (`Percurso` ASC),
  CONSTRAINT `fk_Itinerario_Percurso`
    FOREIGN KEY (`Percurso`)
    REFERENCES `Agencia`.`Percurso` (`idPercurso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Agencia`.`Reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Agencia`.`Reserva` (
  `idReserva` INT NOT NULL AUTO_INCREMENT,
  `DataReserva` DATE NOT NULL,
  `TotalReserva` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `TotalBilhetes` INT NOT NULL DEFAULT 0.00,
  `Cliente` INT NOT NULL,
  `Itinerario` INT NOT NULL,
  PRIMARY KEY (`idReserva`, `Cliente`),
  INDEX `fk_Reserva_Cliente_idx` (`Cliente` ASC),
  INDEX `fk_Reserva_Itinerario_idx` (`Itinerario` ASC),
  CONSTRAINT `fk_Reserva_Cliente`
    FOREIGN KEY (`Cliente`)
    REFERENCES `Agencia`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reserva_Itinerario`
    FOREIGN KEY (`Itinerario`)
    REFERENCES `Agencia`.`Itinerario` (`idItinerario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Agencia`.`ComboioLugar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Agencia`.`ComboioLugar` (
  `NroLugar` INT NOT NULL,
  `NroCarruagem` INT NOT NULL,
  `TipoLugar` CHAR(1) NOT NULL,
  `Comboio` INT NOT NULL,
  PRIMARY KEY (`NroLugar`, `Comboio`),
  CONSTRAINT `fk_Lugar_Comboio`
    FOREIGN KEY (`Comboio`)
    REFERENCES `Agencia`.`Comboio` (`NroComboio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Agencia`.`ReservaBilhete`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Agencia`.`ReservaBilhete` (
  `Reserva` INT NOT NULL,
  `NroCarruagem` INT NOT NULL,
  `TipoLugar` CHAR(1) NOT NULL,
  `NroBilhete` INT NOT NULL,
  `NroLugar` INT NOT NULL,
  `Comboio` INT NOT NULL,
  PRIMARY KEY (`Reserva`, `NroLugar`),
  UNIQUE INDEX `NroBilhete_UNIQUE` (`NroBilhete` ASC),
  INDEX `fk_ReservaBilhete_ComboioLugar_idx` (`NroLugar` ASC, `Comboio` ASC),
  CONSTRAINT `fk_Bilhete_Reserva`
    FOREIGN KEY (`Reserva`)
    REFERENCES `Agencia`.`Reserva` (`idReserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ReservaBilhete_ComboioLugar`
    FOREIGN KEY (`NroLugar` , `Comboio`)
    REFERENCES `Agencia`.`ComboioLugar` (`NroLugar` , `Comboio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
