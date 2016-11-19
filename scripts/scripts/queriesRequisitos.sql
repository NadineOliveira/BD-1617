SELECT * FROM bgum.exemplar;

USE bgum;

-- 1. Saber a designação de todas as coleções existentes.

SELECT DISTINCT Designacao
	FROM coleccao;

-- 2. Saber quantos livros cada colecção tem.

SELECT C.Designacao 'Coleccao',  COUNT(idColeccao) 'Nº Exemplares'
	FROM Livro L, Coleccao C
    WHERE L.Coleccao = C.idColeccao
    GROUP BY idColeccao;

-- 3. Saber lista de nomes dos autores dos livros da biblioteca.

SELECT DISTINCT PrimeirosNomes, Apelido
	FROM Autor;

SELECT DISTINCT CONCAT(PrimeirosNomes,' ',Apelido) AS 'Nome Autor'
	FROM Autor;

-- 4. Saber o apelido e primeiros nomes de um autor.

SELECT DISTINCT PrimeirosNomes 'Nome', Apelido
	FROM Autor;

-- 5. Saber lista de editoras dos livros da biblioteca.

SELECT DISTINCT Designacao AS 'Designacao Editora'
	FROM Editora;

-- 6. Para uma dada editora, saber a sua designação.

SELECT *
	FROM Editora;

-- 7. Pesquisar um livro segundo: ISSN, ISBN, código de barras e título.

SELECT *
	FROM Livro L
    WHERE Titulo = 'Me and My Little Brain';

SELECT *
	FROM Livro L
    WHERE CodBarras = '34884160724';
    
SELECT *
	FROM Livro L
    WHERE ISBN = '440455332';

SELECT *
	FROM Livro L
    WHERE ISSN = '1389-6559';

-- 8. Saber os livros que um autor escreveu.

SELECT *
	FROM AUTOR;
    
SELECT L.*
	FROM `autor-escreve-livro` AL, Livro L 
WHERE Autor = 200 AND AL.Livro = L.idLivro;

-- 9. Saber os livros que uma editora publicou.

SELECT *
	FROM editora;
    

SELECT L.idLivro, L.Titulo, EL.Edicao
	FROM `livro-publicado-editora` EL, Livro L 
WHERE Editora = 5 AND EL.Livro = L.idLivro;

-- 10. Saber os livros pertencentes a uma colecção.

SELECT C.Designacao AS 'Colecção', L.*
	FROM coleccao AS C INNER JOIN Livro as L
		ON C.idColeccao = L.coleccao
WHERE idColeccao = 5;

-- 11. Saber os livros que têm uma dada CDU.

SELECT *
	FROM cdu;
    
SELECT L.*
	FROM livro AS L INNER JOIN cdu AS C
		ON L.idLivro = C.Livro
 WHERE C.cdu = 846.7;

-- 12. Fazer pesquisa por título do livro, que corresponde a obter uma lista de livros que têm no seu título o conjunto de palavras indicado no campo da pesquisa.

SELECT *
	FROM Livro;

SELECT *
	FROM livro
WHERE Titulo LIKE '%the%';


-- 13. Para um dado livro, saber o seu ISSN, ISBN, código de barras, título, editora, autor, edição, CDU, ano de publicação e número de exemplares.

SELECT *
	FROM livro;

SELECT *
	FROM vwUserLivro
	WHERE Título = '101 Dalmatians';

-- alternativa:
SELECT *
	FROM livro
	WHERE idLivro = 92;


-- 14. Saber a localização de livros de uma certa CDU.

SELECT Livro, COUNT(Livro) AS NoCDUS
	FROM CDU
    GROUP BY Livro
    ORDER BY NoCDUS DESC;

-- Faz o inverso, para cada CDU diz o nº de livros
SELECT CDU.CDU, COUNT(Livro) AS NoCDUS
	FROM CDU
    GROUP BY CDU.CDU
    ORDER BY NoCDUS DESC;

SELECT DISTINCT L.idLivro, LC.*
	FROM livro AS L INNER JOIN cdu AS C
		ON L.idLivro = C.livro
        INNER JOIN exemplar AS E
			ON L.idLivro = E.livro
            INNER JOIN localizacao AS LC
				ON E.Localizacao = LC.idLocal
	WHERE CDU = '764.5';
	
-- 15. Para cada exemplar saber o estado de disponibilidade (reservado, requisitado ou não requisitável), o estado de conservação do exemplar bem como a sua localização na biblioteca (piso, estante e prateleira).

SELECT E.idExemplar,
	   dispExemplarToString(E.disponibilidade) AS Disponibilidade,
       L.Piso,
       L.Estante,
       L.Prateleira       
	FROM livro AS LI INNER JOIN exemplar AS E
		ON LI.idLivro = E.livro
        INNER JOIN localizacao AS L
			ON L.idLocal = E.localizacao            
WHERE LI.idLivro = 1;

SELECT dispExemplarToString(1) AS Disponibilidade;

-- 16. Reservar exemplares de um ou mais livros.

SELECT L.Titulo,
	E.idExemplar, 
    dispExemplarToString(E.Disponibilidade) AS Disponibilidade
	FROM Livro AS L INNER JOIN Exemplar AS E
		ON L.idLivro = E.livro;
        
SELECT *
	from exemplar E
    where idExemplar = 8;

CALL sp_efectuar_reserva(8, 516, CURDATE());

SELECT 
	estadoReservaToString(estado) AS 'Estado Reserva',
    Exemplar,
    Utilizador,
    DataReserva
	FROM `exemplar-reservado-utilizador` 
WHERE exemplar = 8 AND Utilizador = 516;

-- 17. Saber data de reserva e seu estado (pendente, exemplar disponível para levantamento, reserva concluída ou cancelada).

SELECT *
	FROM `exemplar-reservado-utilizador`;
    
SELECT 
	estadoReservaToString(Estado) AS 'Estado Reserva',
    Exemplar,
    Utilizador,
    DataReserva
	FROM `exemplar-reservado-utilizador` 
WHERE exemplar = 303 AND Utilizador = 303;

-- 18. Cancelar reserva de exemplar.
    
SELECT *
	FROM `exemplar-reservado-utilizador`;
    
CALL sp_cancelar_reserva(8,516,'2016-02-06');

SELECT *
	FROM `exemplar-reservado-utilizador`
WHERE exemplar = 8 AND utilizador = 516;
    
-- 19. Efetuar requisição de um exemplar.

SELECT *
	FROM exemplar
WHERE disponibilidade = 2;

CALL sp_efectuar_requisicao(312,600,CURDATE(),CURDATE() + INTERVAL 2 WEEK,6);

SELECT *
	FROM requisicao
WHERE utilizador = 600 AND exemplar = 312;

-- 20. Para uma requisição, saber o seu estado (ativa ou não), em que data foi realizada, em que data deverá ser entregue o exemplar, qual o número de renovações efetuado e qual o número máximo de renovações permitidas em vigor na data da reserva.

SELECT idRequisicao,
	   estadoRequisicaoToString(Estado) AS Estado,
       DataRequisicao,
       DataEntrega,
       NroMaxRenovacoes,
       NrRenovacoes
       FROM requisicao;
       
-- 21. Renovar uma requisição, não excedendo o número máximo de renovações permitido.

SELECT *
	FROM Requisicao;
    
CALL sp_renovar_requisicao(2,'2015-01-03',CURDATE() + INTERVAL 2 WEEK);

SELECT *
	FROM Requisicao
WHERE idRequisicao = 2;

-- 22. Concluir requisição, que corresponde à devolução do exemplar requisitado.

SELECT *
	FROM exemplar
WHERE disponibilidade = 0;

SELECT *
	FROM requisicao
WHERE Exemplar = 2;

CALL sp_entregar_exemplar_requisicao(2);

SELECT *
	FROM Requisicao
WHERE idRequisicao = 2;

-- 23. Gerar estatísticas de número de renovações médio e saber quantos utilizadores usam o número máximo de requisições permitidas.

-- SELECT FLOOR(AVG(NrRenovacoes)) AS 'Número Médio de Renovações'
	-- FROM requisicao;
    
SELECT (AVG(NrRenovacoes)) AS 'Número Médio de Renovações'
	FROM requisicao;
    
SELECT COUNT(NroMaxRenovacoes) AS 'Utilizadores que renovaram até ao limite permitido'
	FROM requisicao
    WHERE NrRenovacoes = 6;
    
-- 24. Registar utilizadores internos ou externos como requisitantes.

	-- Utilizador externo
    
SELECT *
	FROM utilizador
WHERE tipo = 'LE';

SELECT *
	FROM exemplar
WHERE disponibilidade = 2;

CALL sp_efectuar_requisicao(1401,800,CURDATE(), CURDATE() + INTERVAL 2 WEEK,6);

SELECT * 
	FROM requisicao
WHERE exemplar = 1401 AND utilizador = 800;

	-- Utilizador Externo
SELECT *
	FROM utilizador;

CALL sp_efectuar_requisicao(1094,762,CURDATE(), CURDATE() + INTERVAL 2 WEEK,6);

SELECT * 
	FROM requisicao
WHERE exemplar = 1094 AND utilizador = 762;

-- 25. Para um dado utilizador, saber o seu tipo, nome, email, CC, número mecanográfico e contacto alternativo.

SELECT *
	FROM Utilizador;

-- 26. Saber os utilizadores que reservaram/requisitaram determinado exemplar.

SELECT *
	FROM exemplar;
    
SELECT *
	FROM `exemplar-reservado-utilizador`;
    
SELECT EU.DataReserva, U.*
	FROM `exemplar-reservado-utilizador` EU INNER JOIN utilizador AS U	
		ON EU.utilizador = U.idUser
WHERE EU.exemplar = 8;
    

