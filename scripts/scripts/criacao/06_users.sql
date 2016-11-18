USE mysql;

CREATE USER 'Funcionario'@'localhost'
IDENTIFIED BY 'bgum*2016';


GRANT ALL PRIVILEGES 
ON bgum.* 
TO 'Funcionario'@'localhost';


show grants for funcionario@localhost;
select * from user;


flush privileges;

REVOKE ALL PRIVILEGES
ON bgum.livro
FROM 'Funcionario'@'localhost';

GRANT ALL PRIVILEGES 
ON *.*
TO Funcionario@localhost;

REVOKE ALL PRIVILEGES
ON *.*
FROM funcionario@localhost;