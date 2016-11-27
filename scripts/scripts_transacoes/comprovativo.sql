USE `agencia`;
DROP procedure IF EXISTS `sp_obter_comprovativo`;

DELIMITER $$
USE `agencia`$$
CREATE PROCEDURE `sp_obter_comprovativo`(IN utilizador_id INT, IN reserva_nro INT)
BEGIN
SELECT * FROM cliente AS cl
	JOIN reserva AS rs
    ON cl.idCliente=rs.Cliente
	JOIN itinerario AS it
    ON rs.itinerario=it.idItinerario
    JOIN percurso AS pc
    ON it.Percurso=pc.idPercurso
    JOIN comboio AS cb
    ON pc.comboio=cb.NroComboio
    JOIN reservabilhete AS rb
    ON rs.idReserva=rb.reserva
    WHERE (cl.idCliente=utilizador_id) AND (rs.idReserva=reserva_nro);
END$$

DELIMITER ;

