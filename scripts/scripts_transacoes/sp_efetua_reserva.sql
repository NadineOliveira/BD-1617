use Agencia;

DROP PROCEDURE IF EXISTS sp_efetuar_reserva;

DELIMITER $$
CREATE PROCEDURE sp_efetuar_reserva_1_bilhete 
	(IN nro_cliente INT,
    IN data_reserva DATE,
     IN nro_itinerario INT,
     IN nro_lugar INT,
     IN nro_carr INT,
     IN tipo_lugar CHAR(1),
     IN nro_bilhete INT)
BEGIN
   -- Declaração de um handler para tratamento de erros.
    
	DECLARE PrecoVenda DECIMAL(10, 2);
    DECLARE id_reserva INT;
    DECLARE nro_comboio INT;
    DECLARE ErroTransacao BOOL DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET ErroTransacao = 1;
    
  
SELECT 
    Preco, NroComboio INTO PrecoVenda, nro_comboio
FROM
    Comboio
        INNER JOIN
    Percurso ON Comboio.NroComboio = Percurso.Comboio
        INNER JOIN
    Itinerario ON Itinerario.Percurso = Percurso.idPercurso
WHERE
    Itinerario.idItinerario = nro_itinerario;
    
SELECT 
    Preco INTO PrecoVenda
FROM
    Itinerario
        INNER JOIN
    Percurso ON Itinerario.Percurso = Percurso.idPercurso
WHERE
    Itinerario.idItinerario = nro_itinerario;
    
    
    -- Verifica restrição dos lugares
    IF tipo_lugar NOT IN ('J', 'C') THEN ROLLBACK; END IF;
	
	
    -- Insere reserva
	INSERT INTO Reserva
			(DataReserva,TotalBilhetes, Cliente,Itinerario)
			VALUES(data_reserva, 1, nro_cliente,nro_itinerario);
	-- Seleciona o último id de reserva
	SELECT max(Reserva.idReserva) INTO id_reserva FROM Reserva;
	-- Insere bilhete
	INSERT INTO ReservaBilhete
    (ReservaBilhete.Reserva, ReservaBilhete.NroCarruagem, ReservaBilhete.TipoLugar, ReservaBilhete.NroBilhete, ReservaBilhete.NroLugar, ReservaBilhete.Comboio)
    VALUES(id_reserva, nro_carr,tipo_lugar, nro_bilhete, nro_lugar, nro_comboio);
    
    -- Atualiza reserva
    UPDATE Reserva
    SET Reserva.TotalReserva = PrecoVenda*1
    WHERE idReserva = id_reserva;
    
    -- Verificação da ocorrência de um erro.
    IF ErroTransacao THEN
		-- Desfazer as operações realizadas.
        ROLLBACK;
    ELSE
		-- Confirmar as operações realizadas.
        COMMIT;
    END IF;

	
END $$

SET SQL_SAFE_UPDATES = 0;

TRUNCATE TABLE ReservaBilhete;

DELETE FROM Reserva;


ALTER TABLE Reserva AUTO_INCREMENT = 1;
SET SQL_SAFE_UPDATES = 1;




CALL sp_efetuar_reserva_1_bilhete (1, current_date(),1,1,1,'J',1);
CALL sp_efetuar_reserva_1_bilhete (1, current_date(),2,3,1,'J',2);
CALL sp_efetuar_reserva_1_bilhete (1, current_date(),2,4,1,'N',2);
SELECT 
    *
FROM
    Reserva
        INNER JOIN
    ReservaBilhete ON Reserva.idReserva = ReservaBilhete.Reserva;