CREATE USER 'agencia.reserva'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de inserção, seleção:*/
GRANT INSERT,SELECT
ON Agencia.Reserva
TO 'agencia.reserva'@'localhost';
/*E retiram-se os privilégioS de atualização e remoção na tabela Cliente :*/
REVOKE UPDATE,DELETE
ON Agencia.Reserva
FROM 'agencia.reserva'@'localhost';