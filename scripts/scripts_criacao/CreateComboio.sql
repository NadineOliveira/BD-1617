CREATE USER 'agencia.comboio'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de inserção e seleção:*/
GRANT INSERT,SELECT
ON Agencia.Comboio
TO 'agencia.comboio'@'localhost';
/*E retiram-se os privilégios de atualização e remoção na tabela Cliente :*/
REVOKE UPDATE,DELETE
ON Agencia.Comboio
FROM 'agencia.comboio'@'localhost';