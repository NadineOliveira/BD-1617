CREATE USER 'agencia.itinerario'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de inserção, seleção:*/
GRANT INSERT,SELECT
ON Agencia.Itinerario
TO 'agencia.itinerario'@'localhost';
/*E retiram-se os privilégios de atualização e remoção na tabela Cliente :*/
REVOKE UPDATE,DELETE
ON Agencia.Itinerario
FROM 'agencia.itinerario'@'localhost';