
-- Universidade do Minho
-- Mestrado Integrado em Engenharia Informática
-- Unidade Curricular de Bases de Dados 2016/2017


USE Agencia;
SET SQL_SAFE_UPDATES = 0;

INSERT INTO Percurso
VALUES
('Braga','Porto',15.00,5),
('Porto','Braga',15.00,5),
('Porto','Lisboa',45.00,8),
('Lisboa','Porto',45.00,8),
('Lisboa','Faro',45.00,12),
('Faro','Lisboa',45.00,12),
('Lisboa','Madrid',85.00,15),
('Lisboa','Paris',105.00,17),
('Lisboa','Amesterdão',205.00,25),
('Lisboa','Londres',225.00,22),
('Lisboa','Berlim',300.00,36),
('Lisboa','Budapeste',260.00,39),
('Lisboa','Praga',240.00,48),
('Lisboa','Viena',235.00,48);

SET SQL_SAFE_UPDATES = 1;


