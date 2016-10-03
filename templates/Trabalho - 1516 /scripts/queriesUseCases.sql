USE bgum;

SELECT *
	FROM requisicao;

SELECT *
	FROM `exemplar-reservado-utilizador`;

SELECT *
	FROM Exemplar;


-- USE CASE 1
-- Requisicao livro sem reserva e disponivel + renovacoes

-- Exemplar 733 (livro 176) disponivel inicialmente
SELECT *
	FROM Exemplar
    WHERE idExemplar = 733;

SELECT *
	FROM utilizador
	WHERE idUser >= 400;

-- 1) User 400 reserva exemplar 733
CALL sp_efectuar_requisicao(733, 400, DATE('2016-02-04'),  DATE('2016-02-04') + INTERVAL 2 WEEK, 6);

SELECT *
	FROM requisicao
    WHERE Exemplar = 733 AND Utilizador = 400;
    
-- 2) User renova requisição 
CALL sp_renovar_requisicao(301, DATE('2016-02-05'), DATE('2016-02-05') + INTERVAL 2 WEEK);

SELECT *
	FROM requisicao
    WHERE idRequisicao = 301;

-- 3) Entregar exemplar
CALL sp_entregar_exemplar_requisicao(733);

-- USE CASE 2
-- Utilizador tenta requisitar livro previamente reservado por outro utilizador, 
-- com o estado na reserva a 1 (ou seja, está disponível para requisição)

-- Exemplar 302 (reservado por Utilizador 302)
-- Tentativa de requisição por Utilizador 500
-- Data de Requisição: Current Date (CURDATE())
-- Data de Entrega: Após duas semanas da requisição (CURDATE() + INTERVAL 2 WEEK)

SELECT *
	FROM `exemplar-reservado-utilizador`
WHERE exemplar = 302;

SELECT *
	FROM Requisicao;
    
-- 1)  Utilizador 500 tenta requisitar
CALL sp_efectuar_requisicao(302,500,CURDATE(),(CURDATE() + INTERVAL 2 WEEK), 6);

SELECT * 
	FROM requisicao
WHERE Exemplar = 301 AND Utilizador = 500;


-- 2) Requisição não é registada, efetua reserva

CALL sp_efectuar_reserva(302,500,CURDATE());

SELECT *
	FROM `exemplar-reservado-utilizador`
WHERE exemplar = 302;

-- USE CASE 3
-- Reservar exemplar apenas disponível para consulta

SELECT *
	FROM exemplar
WHERE Disponibilidade = 0;

-- Exemplar 17
-- Utilizador 405

CALL sp_efectuar_reserva(17,405,CURDATE());

SELECT *
	FROM `exemplar-reservado-utilizador`
WHERE exemplar = 17;

-- USE CASE 4
-- Requisitar exemplar apenas disponível para consulta

SELECT *
	FROM exemplar
WHERE Disponibilidade = 0;

-- Exemplar 1
-- Utilizador 666

CALL sp_efectuar_requisicao(666,1,CURDATE(),(CURDATE() + INTERVAL 2 WEEK),6);

SELECT *
	FROM requisicao
WHERE exemplar = 1;

