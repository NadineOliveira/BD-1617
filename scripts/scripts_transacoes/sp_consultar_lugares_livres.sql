USE `Agencia`;
DROP procedure IF EXISTS `sp_consultar_lugares_livres`;

DELIMITER $$
CREATE PROCEDURE `sp_consultar_lugares_livres`(IN itinerario_nro int)
BEGIN

-- Obtem número do comboio correspondente ao itinerario
SELECT 
    NroComboio
INTO nro_comboio FROM
    Comboio
        INNER JOIN
    Percurso ON Comboio.NroComboio = Percurso.Comboio
        INNER JOIN
    Itinerario ON Itinerario.Percurso = Percurso.idPercurso
WHERE
    Itinerario.idItinerario = itinerario_nro;


-- Obtem os lugares livres do comboio correspondente ao itinerario
SELECT 
    ComboioLugar.NroLugar,
    ComboioLugar.NroCarruagem,
    ComboioLugar.TipoLugar,
    ComboioLugar.Comboio
FROM
    (
	SELECT 
        ReservaBilhete.NroLugar,
            ReservaBilhete.NroCarruagem,
            ReservaBilhete.TipoLugar,
            ReservaBilhete.Comboio
    FROM
        Reserva
    INNER JOIN ReservaBilhete ON Reserva.idReserva = ReservaBilhete.Reserva
    WHERE
        Reserva.Itinerario = itinerario_nro
		) AS T
        RIGHT JOIN
    ComboioLugar ON T.NroLugar = ComboioLugar.NroLugar
        AND T.Comboio = ComboioLugar.Comboio
WHERE
    ComboioLugar.Comboio = nro_comboio
        AND T.NroLugar IS NULL
        AND T.Comboio IS NULL;


END$$
DELIMITER $$
CALL sp_consultar_lugares_livres(1);
--

