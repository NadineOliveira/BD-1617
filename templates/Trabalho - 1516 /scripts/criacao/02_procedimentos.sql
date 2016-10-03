USE bgum;

delimiter \\
CREATE PROCEDURE sp_efectuar_requisicao(IN p_IdExemplar INT, IN p_Utilizador INT, IN p_DataRequisicao DATE,  IN p_DataEntrega DATE, IN p_NrMaxRenovacoes INT)
BEGIN

DECLARE mustRollback INT DEFAULT 0;
DECLARE v_numeroReservasOutrosUtilizadores INT DEFAULT 0;
DECLARE v_disponibilidadeExemplar INT;
DECLARE Erro BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;

SET autocommit = 0;
SET SQL_SAFE_UPDATES = 0;

START TRANSACTION;

SELECT E.Disponibilidade INTO v_disponibilidadeExemplar
	FROM Exemplar E
    WHERE E.idExemplar = p_IdExemplar;

IF v_disponibilidadeExemplar != 2 THEN SET mustRollback = 1; END IF;

SELECT COUNT(Exemplar) INTO v_numeroReservasOutrosUtilizadores
	FROM `exemplar-reservado-utilizador` ERU
    WHERE Exemplar = p_IdExemplar AND Utilizador != p_Utilizador AND Estado = 1;

IF v_numeroReservasOutrosUtilizadores > 0 THEN SET mustRollback = 1; END IF;

INSERT INTO requisicao
(DataRequisicao, DataEntrega, Estado, NroMaxRenovacoes, NrRenovacoes, Exemplar, Utilizador)
VALUES
(p_DataRequisicao, p_DataEntrega, 0, p_NrMaxRenovacoes, 0, p_IdExemplar, p_Utilizador);

    
UPDATE `exemplar-reservado-utilizador`
	SET Estado = 2
    WHERE Estado = 1 AND Exemplar = p_IdExemplar AND Utilizador = p_Utilizador;

UPDATE exemplar
	SET Disponibilidade = 1
    WHERE idExemplar = p_IdExemplar;

IF Erro OR mustRollback = 1 THEN ROLLBACK; ELSE COMMIT; END IF;

SET SQL_SAFE_UPDATES = 1;

END;\\
delimiter ;

delimiter \\
CREATE PROCEDURE sp_renovar_requisicao(IN p_idRequisicao INT, IN p_dataRequisicao DATE, IN p_dataEntrega DATE)
BEGIN

DECLARE mustRollback INT DEFAULT 0;
DECLARE v_numRenovacoes INT;
DECLARE v_numMaxRenovacoes INT;
DECLARE Erro BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;

SET autocommit = 0;
SET SQL_SAFE_UPDATES = 0;

START TRANSACTION;

SELECT NrRenovacoes, NroMaxRenovacoes INTO v_numRenovacoes, v_numMaxRenovacoes
	FROM requisicao
	WHERE idRequisicao = p_idRequisicao;

IF v_numRenovacoes = v_numMaxRenovacoes THEN SET mustRollback = 1; END IF;

UPDATE requisicao
	SET NrRenovacoes = NrRenovacoes + 1, DataRequisicao = p_dataRequisicao, DataEntrega = p_dataEntrega
	WHERE idRequisicao = p_idRequisicao;

IF Erro OR mustRollback = 1 THEN ROLLBACK; ELSE COMMIT; END IF;

SET SQL_SAFE_UPDATES = 1;

END;\\
delimiter ;

delimiter \\
CREATE PROCEDURE sp_entregar_exemplar_requisicao(IN p_idExemplar INT)
BEGIN

DECLARE mustRollback INT DEFAULT 0;
DECLARE v_DisponibilidadeExemplar INT;
DECLARE v_idRequisicao INT;
DECLARE Erro BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;

SET autocommit = 0;
SET SQL_SAFE_UPDATES = 0;

START TRANSACTION;

SELECT E.Disponibilidade INTO v_DisponibilidadeExemplar
	FROM exemplar E
    WHERE idExemplar = p_idExemplar;
    
IF v_DisponibilidadeExemplar != 1 OR Erro THEN SET mustRollback = 1; END IF;

UPDATE exemplar
	SET Disponibilidade = 2
	WHERE idExemplar = p_idExemplar;
    
IF Erro THEN SET mustRollback = 1; END IF;

SELECT idRequisicao INTO v_idRequisicao
	FROM Requisicao R
    WHERE R.Estado = 0 AND R.Exemplar = p_idExemplar;

IF Erro THEN SET mustRollback = 1; END IF;

UPDATE requisicao
	SET Estado = 1
	WHERE idRequisicao = v_idRequisicao;

IF Erro or mustRollback = 1 THEN ROLLBACK; ELSE COMMIT; END IF;
SET SQL_SAFE_UPDATES = 1;
END;\\
delimiter ;

delimiter \\
CREATE PROCEDURE sp_efectuar_reserva(IN p_idExemplar INT, IN p_idUtilizador INT, IN p_DataReserva DATE)
BEGIN

DECLARE mustRollback INT DEFAULT 0;
DECLARE v_numReservas INT DEFAULT 0;
DECLARE v_disponibilidade INT;
DECLARE v_estadoAInserir INT;
DECLARE Erro BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;

SET autocommit = 0;
SET SQL_SAFE_UPDATES = 0;

START TRANSACTION;

SELECT E.Disponibilidade INTO v_disponibilidade
	FROM exemplar E
    WHERE E.idExemplar = p_idExemplar;

SELECT COUNT(Exemplar) INTO v_numReservas
	FROM `exemplar-reservado-utilizador`
    WHERE Exemplar = p_idExemplar AND (Estado = 0 OR Estado = 1);

IF v_disponibilidade = 0 THEN SET mustRollback = 1; END IF;
IF v_disponibilidade = 1 OR v_numReservas > 0 THEN SET v_estadoAInserir = 0; END IF;
IF v_disponibilidade = 2 AND v_numReservas = 0 THEN SET v_estadoAInserir = 1; END IF;

INSERT INTO `exemplar-reservado-utilizador`
(Exemplar,Utilizador, DataReserva, Estado)
VALUES
(p_idExemplar, p_idUtilizador, p_DataReserva, v_estadoAInserir);

IF Erro OR mustRollback = 1 THEN ROLLBACK; ELSE COMMIT; END IF;
SET SQL_SAFE_UPDATES = 1;
END;\\
delimiter ;

delimiter \\
CREATE PROCEDURE sp_cancelar_reserva(IN p_idExemplar INT, IN p_idUtilizador INT, IN p_DataReserva DATE)
BEGIN

DECLARE mustRollback INT DEFAULT 0;
DECLARE v_utilizadoresEmEspera INT;
DECLARE v_disponibilidade INT;
DECLARE v_estadoAInserir INT;
DECLARE Erro BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;

SET autocommit = 0;
SET SQL_SAFE_UPDATES = 0;
START TRANSACTION;

UPDATE `exemplar-reservado-utilizador`
	SET Estado = 3
    WHERE Exemplar = p_idExemplar AND Utilizador = p_idUtilizador AND DataReserva = p_DataReserva;

IF Erro THEN SET mustRollback = 1; END IF;

SELECT COUNT(Exemplar) INTO v_utilizadoresEmEspera
	FROM `exemplar-reservado-utilizador` ERU
    WHERE Estado = 1 AND Exemplar = p_idExemplar;

IF Erro THEN SET mustRollback = 1; END IF;

IF v_utilizadoresEmEspera = 0 THEN
	UPDATE `exemplar-reservado-utilizador`
		SET Estado = 1
		WHERE Exemplar = p_idExemplar AND Estado = 0
		ORDER BY DataReserva ASC
		LIMIT 1;
END IF;

IF Erro OR mustRollback = 1 THEN ROLLBACK; ELSE COMMIT; END IF;
SET SQL_SAFE_UPDATES = 1;
END;\\
delimiter ;

delimiter \\
CREATE PROCEDURE sp_localizacao_exemplares(IN p_titulo VARCHAR(250))
BEGIN

SELECT DISTINCT Loc.*
	FROM (SELECT *
			FROM livro
			WHERE Titulo = p_titulo) L, Exemplar E, localizacao Loc
	WHERE L.idLivro = E.Livro AND E.Localizacao = Loc.idLocal;

END;\\
delimiter ;


delimiter \\
CREATE FUNCTION dispExemplarToString(disponibilidade INT) RETURNS TEXT
BEGIN

DECLARE dispMsg VARCHAR(50);

CASE disponibilidade
	WHEN 0 THEN SET dispMsg='Nao Requisitavel';
	WHEN 1 THEN SET dispMsg='Requisitado';
	WHEN 2 THEN SET dispMsg='Disponivel';
	ELSE
		BEGIN
		SET dispMsg='Disponibilidade Invalida';
		END;
END CASE;

RETURN dispMsg;

END;\\
delimiter ;

delimiter \\
CREATE FUNCTION estadoRequisicaoToString(estado INT) RETURNS TEXT
BEGIN

DECLARE dispMsg VARCHAR(50);

CASE estado
	WHEN 0 THEN SET dispMsg='Activa';
	WHEN 1 THEN SET dispMsg='Livro Entregue';
	ELSE
		BEGIN
		SET dispMsg='Estado Invalido';
		END;
END CASE;

RETURN dispMsg;

END;\\
delimiter ;

delimiter \\
CREATE FUNCTION estadoReservaToString(estado INT) RETURNS TEXT
BEGIN

DECLARE dispMsg VARCHAR(50);

CASE estado
	WHEN 0 THEN SET dispMsg='Efectuada';
	WHEN 1 THEN SET dispMsg='Pronto a levantar';
	WHEN 2 THEN SET dispMsg='Exemplar levantado';
	WHEN 2 THEN SET dispMsg='Cancelada';
  ELSE
	BEGIN
    SET dispMsg='Estado Invalido';
    END;
    
END CASE;

RETURN dispMsg;

END;\\
delimiter ;



