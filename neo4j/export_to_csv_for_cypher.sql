DELIMITER $$
CREATE PROCEDURE `export_to_csv_for_cypher` (
IN nome VARCHAR(255), 
IN nome_schema VARCHAR(255))
BEGIN
/** No caso do windows a diretoria tem que ser colocada à frente de OUTFILE
 * dentro de \'CAMINHO/PARA/DIRETORIA\' (notar a barra de escape das plicas */

SET @SQL = (

SELECT 
    CONCAT('SELECT * INTO OUTFILE \'/var/lib/mysql-files/\', LCASE(nome), '.csv\' FIELDS TERMINATED BY \',\' ENCLOSED BY \'"\' LINES TERMINATED BY \'\n\' FROM ( SELECT ',
            GROUP_CONCAT(CONCAT(' \'', COLUMN_NAME, '\' ')),
            '  UNION select * from',  nome, ') as tmp ;')
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = nome
        AND TABLE_SCHEMA = nome_schema
ORDER BY ORDINAL_POSITION

);

PREPARE stmt FROM @SQL;
EXECUTE stmt;

END
$$

