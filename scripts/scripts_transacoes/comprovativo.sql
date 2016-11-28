USE `Agencia`;
DROP procedure IF EXISTS `sp_obter_comprovativo`;

DELIMITER $$
USE `Agencia`$$
CREATE PROCEDURE `sp_obter_comprovativo`(IN utilizador_id INT, IN reserva_nro INT)
BEGIN
SELECT 
    cl.*, rs.*, 
    it.DataHoraPartida, it.DataHoraChegada, 
    pc.LocalPartida, pc.LocalChegada, rb.*
FROM
    Cliente AS cl
        JOIN
    Reserva AS rs ON cl.idCliente = rs.Cliente
        JOIN
    Itinerario AS it ON rs.Itinerario = it.idItinerario
        JOIN
    Percurso AS pc ON it.Percurso = pc.idPercurso
        JOIN
    Comboio AS cb ON pc.Comboio = cb.NroComboio
        JOIN
    ReservaBilhete AS rb ON rs.idReserva = rb.Reserva
WHERE
    (cl.idCliente = utilizador_id)
        AND (rs.idReserva = reserva_nro);
END$$

DELIMITER $$


