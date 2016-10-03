USE bgum;

CREATE VIEW vwUserLivro AS
SELECT 
	Titulo AS 'Título', 
    A.PrimeirosNomes AS 'Nome Autor',
    A.apelido AS 'Apelido', 
    C.Designacao AS 'Coleção', 
    ED.Designacao AS 'Editora',
    LE.Edicao AS 'Número da Edição',
    LE.Ano AS 'Ano de Edição',
    COUNT(E.livro) AS 'Número de Exemplares',
    CodBArras AS 'Código de Barras', 
    ISBN, 
    ISSN
FROM livro AS L INNER JOIN coleccao AS C
    ON L.Coleccao = C.idColeccao
    LEFT JOIN exemplar as E
		ON (L.idlivro = E.livro)
		LEFT OUTER JOIN `autor-escreve-livro` AS AL
			ON L.idLivro = AL.livro
        INNER JOIN autor AS A
			ON A.idAutor = AL.autor
			LEFT JOIN `livro-publicado-editora` as LE
				ON (L.idlivro = LE.livro)
				INNER JOIN editora as ED
					ON ED.idEditora = LE.editora             
GROUP BY L.titulo;


CREATE VIEW vwExemplares AS
SELECT 
	L.Titulo AS 'Título',
	condicao AS 'Condição', 
    Loc.Piso, 
    Loc.Estante, 
    Loc.Prateleira
FROM exemplar AS E INNER JOIN localizacao AS Loc
	ON E.localizacao = Loc.idLocal
    INNER JOIN livro AS L
		ON L.idLivro = E.Livro
GROUP BY L.titulo;