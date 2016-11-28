CREATE USER 'agencia.percurso'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de seleção:*/
GRANT SELECT
ON Agencia.Percurso
TO 'agencia.percurso'@'localhost';
/*E retiram-se oS privilégios de inserção,atualização e remoção na tabela Cliente :*/
REVOKE UPDATE,DELETE
ON Agencia.Percurso
FROM 'agencia.percurso'@'localhost';