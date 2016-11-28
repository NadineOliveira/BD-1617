CREATE USER 'agencia.comboio'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de seleção:*/
GRANT SELECT
ON Agencia.Comboio
TO 'agencia.comboio'@'localhost';
/*E retiram-se os privilégios de inserção,atualização e remoção na tabela Cliente :*/
REVOKE INSERT,UPDATE,DELETE
ON Agencia.Comboio
FROM 'agencia.comboio'@'localhost';