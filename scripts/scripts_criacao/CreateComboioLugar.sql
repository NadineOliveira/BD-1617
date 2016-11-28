CREATE USER 'agencia.comboiolugar'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de seleção:*/
GRANT SELECT
ON Agencia.ComboioLugar
TO 'agencia.comboiolugar'@'localhost';
/*E retiram-se os privilégios de inserção,atualização e remoção na tabela Cliente :*/
REVOKE INSERT,UPDATE,DELETE
ON Agencia.ComboioLugar
FROM 'agencia.comboiolugar'@'localhost';