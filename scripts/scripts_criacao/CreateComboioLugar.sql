CREATE USER 'agencia.comboiolugar'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de inserção, seleção:*/
GRANT INSERT,SELECT
ON Agencia.ComboioLugar
TO 'agencia.comboiolugar'@'localhost';
/*E retiram-se os privilégios de atualização e remoção na tabela Cliente :*/
REVOKE UPDATE,DELETE
ON Agencia.ComboioLugar
FROM 'agencia.comboiolugar'@'localhost';