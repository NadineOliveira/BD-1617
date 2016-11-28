CREATE USER 'agencia.reservabilhete'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de inserção, seleção:*/
GRANT INSERT,SELECT
ON Agencia.ReservaBilhete
TO 'agencia.reservabilhete'@'localhost';
/*E retiram-se oS privilégios de atualização e remoção na tabela Cliente :*/
REVOKE UPDATE,DELETE
ON Agencia.ReservaBilhete
FROM 'agencia.reservabilhete'@'localhost';