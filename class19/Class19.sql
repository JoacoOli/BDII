-- 1. Create the user data_analyst
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'password';

-- 2. Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';

-- 3. Show the granted permissions
SHOW GRANTS FOR 'data_analyst'@'localhost';

-- 4. Login with this user and try to create a table. Show the result of that operation
-- Explicación:
-- Al intentar crear una tabla con el usuario 'data_analyst', obtendrás un error ya que no tiene permisos para ejecutar el comando CREATE.
-- El resultado será:
-- ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'tabla'
/*
mysql> CREATE TABLE tabla(
    numero INT NOT NULL,
    nombre VARCHAR(55),
    PRIMARY KEY(numero)
) ENGINE=INNODB;
*/

-- 5. Try to update a title of a film. Write the update script
-- Explicación:
-- Al intentar ejecutar un UPDATE en la tabla 'film' con el usuario 'data_analyst', el comando se ejecuta correctamente ya que tiene permisos de actualización.
-- El resultado será una fila afectada.
-- Query:
/*
mysql> UPDATE film
    SET title = 'New Movie Title', 
        rental_rate = 3.99
    WHERE film_id = 1;
*/

-- 6. Revoke the UPDATE permission using root or any admin user. Write the command
-- Explicación:
-- Aquí revocamos el permiso de UPDATE para que el usuario 'data_analyst' ya no pueda actualizar registros en las tablas de sakila.
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';

-- 7. Login again with data_analyst and try again the update done in step 5. Show the result
-- Explicación:
-- Al intentar realizar el mismo UPDATE que en el paso anterior, el sistema devolverá un error indicando que no se tienen los permisos necesarios.
-- El resultado será:
-- ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'
/*
mysql> UPDATE film
    SET title = 'New Movie Title', 
        rental_rate = 3.99
    WHERE film_id = 1;
*/

-- Fin del archivo SQL
