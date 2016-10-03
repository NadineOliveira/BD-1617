USE bgum;

delimiter \\
CREATE TRIGGER actualiza_reservas AFTER UPDATE ON exemplar
FOR EACH ROW
BEGIN

SET SQL_SAFE_UPDATES = 0;
-- Livro livre (2) passa a requisitado (1)
IF OLD.Disponibilidade = 2 AND NEW.Disponibilidade = 1 
	THEN
    -- Ver todos os livros prontos a levantar (1) e mudar estado
    -- para reserva pedida (0)
		UPDATE `exemplar-reservado-utilizador`
			SET Estado = 0
            WHERE Exemplar = NEW.idExemplar AND Estado = 1;
END IF;

-- Livro requisitado (1) passa a livre (2)
IF OLD.Disponibilidade = 1 AND NEW.Disponibilidade = 2
	THEN
    -- Ver todos as reservas com reserva pedida (0) e mudar estado
    -- para livro pronto a levantar
		UPDATE `exemplar-reservado-utilizador`
			SET Estado = 1
            WHERE Exemplar = NEW.idExemplar AND Estado = 0
            ORDER BY DataReserva ASC
            LIMIT 1;
END IF;

SET SQL_SAFE_UPDATES = 1;

END;\\
delimiter ;

delimiter \\
CREATE TRIGGER tr_verificaDispExemplar BEFORE INSERT ON exemplar
FOR EACH ROW
BEGIN

    DECLARE mensagem VARCHAR(128);
    if NEW.Disponibilidade NOT IN(0,1,2) THEN
        set mensagem = concat('Atributo disponibilidade NOT IN (0,1,2). Valor:', cast(NEW.Disponibilidade AS CHAR));
        signal sqlstate '45000' set message_text = mensagem;
    end if;

END;\\
delimiter ;

delimiter \\
CREATE TRIGGER tr_verificaEstadoReq BEFORE INSERT ON requisicao
FOR EACH ROW
BEGIN

    DECLARE mensagem VARCHAR(128);
    
    if NEW.Estado NOT IN(0,1) THEN
        set mensagem = concat('Atributo estado NOT IN (0,1). Valor:', cast(NEW.Estado AS CHAR));
        signal sqlstate '45000' set message_text = mensagem;
    end if;

END;\\
delimiter ;

delimiter \\
CREATE TRIGGER tr_verificaTipoUser BEFORE INSERT ON utilizador
FOR EACH ROW
BEGIN

    DECLARE mensagem VARCHAR(128);
    
    if NEW.Tipo NOT IN('A','PG','ID','D','F','LE','X') THEN
        set mensagem = concat('Atributo tipo invalido. Valor:', NEW.Tipo);
        signal sqlstate '45000' set message_text = mensagem;
    end if;

END;\\
delimiter ;

delimiter \\
CREATE TRIGGER tr_verificaEstadoReserva BEFORE INSERT ON `exemplar-reservado-utilizador`
FOR EACH ROW
BEGIN

    DECLARE mensagem VARCHAR(128);
    
    if NEW.Estado NOT IN(0,1,2,3) THEN
        set mensagem = concat('Atributo estado invalido. Valor:', NEW.Estado);
        signal sqlstate '45000' set message_text = mensagem;
    end if;

END;\\
delimiter ;


