CREATE USER 'agencia.itinerario'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de seleção:*/
GRANT SELECT
ON Agencia.Itinerario
TO 'agencia.itinerario'@'localhost';
/*E retiram-se os privilégios de inserção,atualização e remoção na tabela Cliente :*/
REVOKE INSERT,UPDATE,DELETE
ON Agencia.Itinerario
FROM 'agencia.itinerario'@'localhost';