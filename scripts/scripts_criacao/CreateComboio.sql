CREATE USER 'agencia.comboio'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de inserção, atualização e seleção:*/
GRANT INSERT,UPDATE,SELECT
ON Agencia.Comboio
TO 'agencia.comboio'@'localhost';
/*E retira-se o privilégio de remoção na tabela Cliente :*/
REVOKE DELETE
ON Agencia.Comboio
FROM 'agencia.comboio'@'localhost';