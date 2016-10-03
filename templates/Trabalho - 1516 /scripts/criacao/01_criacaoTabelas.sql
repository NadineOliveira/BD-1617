-- Unidade Curricular de Base de Dados
-- Ano Lectivo 2015/2016
-- Script criacao BGUM

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

-- -----------------------------------------------------
-- Schema BGUM
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `BGUM` ;

CREATE SCHEMA IF NOT EXISTS `BGUM` DEFAULT CHARACTER SET utf8 ;
USE `BGUM` ;

-- -----------------------------------------------------
-- Table `Coleccao`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Coleccao` ;

CREATE TABLE IF NOT EXISTS `Coleccao` (
  `idColeccao` INT NOT NULL AUTO_INCREMENT,
  `Designacao` VARCHAR(75) NOT NULL,
  PRIMARY KEY (`idColeccao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Livro`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Livro` ;

CREATE TABLE IF NOT EXISTS `Livro` (
  `idLivro` INT NOT NULL AUTO_INCREMENT,
  `Titulo` VARCHAR(250) NOT NULL,
  `CodBarras` VARCHAR(25) NOT NULL,
  `ISBN` VARCHAR(13) NOT NULL,
  `ISSN` VARCHAR(10) NOT NULL,
  `Coleccao` INT NULL,
  PRIMARY KEY (`idLivro`),
  INDEX `fk_livro_coleccao_idx` (`Coleccao` ASC),
  CONSTRAINT `fk_livro_coleccao`
    FOREIGN KEY (`Coleccao`)
    REFERENCES `Coleccao` (`idColeccao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Autor`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Autor` ;

CREATE TABLE IF NOT EXISTS `Autor` (
  `idAutor` INT NOT NULL AUTO_INCREMENT,
  `PrimeirosNomes` VARCHAR(75) NOT NULL,
  `Apelido` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`idAutor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Autor-Escreve-Livro`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Autor-Escreve-Livro` ;

CREATE TABLE IF NOT EXISTS `Autor-Escreve-Livro` (
  `Livro` INT NOT NULL,
  `Autor` INT NOT NULL,
  PRIMARY KEY (`Livro`, `Autor`),
  INDEX `fk_Livro_has_Autor_Autor1_idx` (`Autor` ASC),
  INDEX `fk_Livro_has_Autor_Livro_idx` (`Livro` ASC),
  CONSTRAINT `fk_Livro_has_Autor_Livro`
    FOREIGN KEY (`Livro`)
    REFERENCES `Livro` (`idLivro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Livro_has_Autor_Autor1`
    FOREIGN KEY (`Autor`)
    REFERENCES `Autor` (`idAutor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Editora`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Editora` ;

CREATE TABLE IF NOT EXISTS `Editora` (
  `idEditora` INT NOT NULL AUTO_INCREMENT,
  `Designacao` VARCHAR(75) NOT NULL,
  PRIMARY KEY (`idEditora`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Livro-Publicado-Editora`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Livro-Publicado-Editora` ;

CREATE TABLE IF NOT EXISTS `Livro-Publicado-Editora` (
  `Livro` INT NOT NULL,
  `Editora` INT NOT NULL,
  `Edicao` INT NOT NULL,
  `Ano` YEAR NOT NULL,
  PRIMARY KEY (`Livro`, `Editora`, `edicao`),
  INDEX `fk_Livro_has_Editora_Editora1_idx` (`Editora` ASC),
  INDEX `fk_Livro_has_Editora_Livro1_idx` (`Livro` ASC),
  CONSTRAINT `fk_Livro_has_Editora_Livro1`
    FOREIGN KEY (`Livro`)
    REFERENCES `Livro` (`idLivro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Livro_has_Editora_Editora1`
    FOREIGN KEY (`Editora`)
    REFERENCES `Editora` (`idEditora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Localizacao`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Localizacao` ;

CREATE TABLE IF NOT EXISTS `Localizacao` (
  `idLocal` INT NOT NULL AUTO_INCREMENT,
  `Piso` INT NOT NULL,
  `Estante` INT NOT NULL,
  `Prateleira` INT NOT NULL,
  PRIMARY KEY (`idLocal`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Exemplar`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Exemplar` ;

CREATE TABLE IF NOT EXISTS `Exemplar` (
  `idExemplar` INT NOT NULL AUTO_INCREMENT,
  `Condicao` VARCHAR(75) NOT NULL,
  `Disponibilidade` INT NOT NULL,
  `Localizacao` INT NOT NULL,
  `Livro` INT NOT NULL,
  PRIMARY KEY (`idExemplar`),
  INDEX `fk_Exemplar_Localizacao1_idx` (`Localizacao` ASC),
  INDEX `fk_Exemplar_Livro1_idx` (`Livro` ASC),
  CONSTRAINT `fk_Exemplar_Localizacao1`
    FOREIGN KEY (`Localizacao`)
    REFERENCES `Localizacao` (`idLocal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Exemplar_Livro1`
    FOREIGN KEY (`Livro`)
    REFERENCES `Livro` (`idLivro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Utilizador`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Utilizador` ;

CREATE TABLE IF NOT EXISTS `Utilizador` (
  `idUser` INT NOT NULL AUTO_INCREMENT,
  `Tipo` VARCHAR(2) NOT NULL,
  `Nome` VARCHAR(75) NOT NULL,
  `Email` VARCHAR(75) NOT NULL,
  `CC` VARCHAR(10) NOT NULL,
  `NroMecanografico` VARCHAR(10) NOT NULL,
  `Telefone` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idUser`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Requisicao`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Requisicao` ;

CREATE TABLE IF NOT EXISTS `Requisicao` (
  `idRequisicao` INT NOT NULL AUTO_INCREMENT,
  `DataRequisicao` DATE NOT NULL,
  `DataEntrega` DATE NOT NULL,
  `Estado` INT NOT NULL,
  `NroMaxRenovacoes` INT NOT NULL DEFAULT 6,
  `NrRenovacoes` INT NOT NULL,
  `Exemplar` INT NOT NULL,
  `Utilizador` INT NOT NULL,
  PRIMARY KEY (`idRequisicao`),
  INDEX `fk_Requisicao_Exemplar1_idx` (`Exemplar` ASC),
  INDEX `fk_Requisicao_Utilizador_idx` (`Utilizador` ASC),
  CONSTRAINT `fk_Requisicao_Exemplar1`
    FOREIGN KEY (`Exemplar`)
    REFERENCES `Exemplar` (`idExemplar`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Requisicao_Utilizador`
    FOREIGN KEY (`Utilizador`)
    REFERENCES `Utilizador` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Exemplar-reservado-Utilizador`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Exemplar-reservado-Utilizador` ;

CREATE TABLE IF NOT EXISTS `Exemplar-reservado-Utilizador` (
  `Exemplar` INT NOT NULL,
  `Utilizador` INT NOT NULL,
  `DataReserva` DATE NOT NULL,
  `Estado` INT NOT NULL,
  PRIMARY KEY (`Exemplar`, `Utilizador`, `DataReserva`),
  INDEX `fk_Exemplar_has_Utilizador_Utilizador1_idx` (`Utilizador` ASC),
  INDEX `fk_Exemplar_has_Utilizador_Exemplar1_idx` (`Exemplar` ASC),
  CONSTRAINT `fk_Exemplar_has_Utilizador_Exemplar1`
    FOREIGN KEY (`Exemplar`)
    REFERENCES `Exemplar` (`idExemplar`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Exemplar_has_Utilizador_Utilizador1`
    FOREIGN KEY (`Utilizador`)
    REFERENCES `Utilizador` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CDU`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `CDU` ;

CREATE TABLE IF NOT EXISTS `CDU` (
  `CDU` VARCHAR(45) NOT NULL,
  `Livro` INT NOT NULL,
  PRIMARY KEY (`CDU`, `Livro`),
  INDEX `fk_CDU_Livro1_idx` (`Livro` ASC),
  CONSTRAINT `fk_CDU_Livro1`
    FOREIGN KEY (`Livro`)
    REFERENCES `Livro` (`idLivro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
