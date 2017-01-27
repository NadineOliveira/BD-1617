Use Agencia;

DROP PROCEDURE `sp_efetuar_reserva_1_bilhete`;	
DELIMITER $$
CREATE PROCEDURE `sp_efetuar_reserva_1_bilhete`(IN nro_cliente INT,
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
    Itinerario.idItinerario = 1;
    
SELECT 
    Preco 
FROM
    Itinerario
        INNER JOIN
    Percurso ON Itinerario.Percurso = Percurso.idPercurso
WHERE
    Itinerario.idItinerario = 1;
    
    
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
    /** Comentar para fazer trigger */
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

	
END$$
DELIMITER ;
    
DROP TRIGGER tgUpdatePreco;
DELIMITER $$
CREATE TRIGGER tgUpdatePreco 
	AFTER INSERT ON ReservaBilhete
	FOR EACH ROW
BEGIN
DECLARE PrecoVenda DECIMAL(10, 2);
DECLARE TotalBil INT;

SELECT DISTINCT
    Percurso.Preco, Reserva.TotalBilhetes INTO PrecoVenda, TotalBil
FROM
    ReservaBilhete
        INNER JOIN
    Reserva ON ReservaBilhete.Reserva = Reserva.idReserva
        INNER JOIN
    Itinerario ON Reserva.Itinerario = Itinerario.idItinerario
        INNER JOIN
    Percurso ON Itinerario.Percurso = Percurso.idPercurso
WHERE
    ReservaBilhete.Reserva = NEW.Reserva;  

UPDATE Reserva
    SET Reserva.TotalReserva = Reserva.TotalReserva + PrecoVenda*TotalBil
    WHERE idReserva = NEW.Reserva;
	
END $$
DELIMITER ;

select max(idReserva) from Reserva;

CALL sp_efetuar_reserva_1_bilhete (1, current_date(),200,1,1,'J',99999);

select * from Reserva where idReserva = 1106;
 
    
    
    