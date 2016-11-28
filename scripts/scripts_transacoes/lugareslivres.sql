USE `agencia`;
DROP procedure IF EXISTS `sp_consultar_lugares_livres`;

DELIMITER $$
CREATE PROCEDURE `sp_consultar_lugares_livres`(IN itinerario_nro int)
BEGIN
SELECT cbl.NroLugar FROM reserva AS rs
JOIN reservabilhete AS rb
ON rs.idReserva=rb.Reserva
JOIN itinerario AS it
ON rs.itinerario=it.idItinerario
JOIN percurso AS pc
ON it.Percurso=pc.idPercurso
JOIN comboio AS cb
ON pc.Comboio=cb.NroComboio
JOIN comboiolugar AS cbl
ON cbl.Comboio=cb.NroComboio
WHERE (rb.NroLugar<>cbl.NroLugar) AND (it.idItinerario=itinerario_nro);


END$$
DELIMITER ;
