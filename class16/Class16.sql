# Insert a new employee to , but with an null email. Explain what happens.
INSERT INTO employees (employeeNumber, lastName, firstName, extension, officeCode, reportsTo, jobTitle, email) 
VALUES (7834, 'Oliveros', 'Joaquin', 'x9273', 1, 1002, 'VP Marketing', NULL);

-- Explicación: El error "Error Code: 1048. Column 'email' cannot be null" ocurre porque la columna email tiene la restricción NOT NULL. Esto significa que no se permite almacenar valores NULL en esa columna. Para evitar el error, debes proporcionar un valor válido para email o ajustar la definición de la tabla eliminando la restricción NOT NULL si es necesario.
# Run the first the query
UPDATE employees SET employeeNumber = employeeNumber - 20;

-- Explicación: Este comando resta 20 al valor de employeeNumber para todas las filas en la tabla. El proceso se ejecuta sin problemas a menos que cause duplicados en la columna employeeNumber, que es una clave primaria y debe ser única. En este caso, la operación fallará si hay algún conflicto de duplicado.
# What did happen? Explain. Then run this other
UPDATE employees SET employeeNumber = employeeNumber + 20;

-- Explicación: Este comando intenta sumar 20 al valor de employeeNumber. Sin embargo, si en algún momento genera un número de empleado que ya existe, se producirá un error debido a la restricción de clave primaria que impide duplicados. Este problema puede ocurrir cuando se hace una operación que afecta a varios registros, ya que los cambios se aplican fila por fila.
#Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
ALTER TABLE employees 
ADD COLUMN age INT DEFAULT 16,
ADD CONSTRAINT chk_age CHECK (age BETWEEN 16 AND 70);

-- Explicación: Este comando agrega una nueva columna age con un valor por defecto de 16, y una restricción (CHECK) que asegura que los valores estén entre 16 y 70. El error inicial se debe a que ya existen filas en la tabla con valores que no cumplen la condición CHECK. Para evitar este problema, puedes asignar valores predeterminados (como DEFAULT 16) y luego actualizar las filas que no cumplan antes de aplicar la restricción.
# Describe the referential integrity between tables film, actor and film_actor in sakila db.
-- Explicación: La tabla film_actor es una tabla intermedia que establece una relación de muchos a muchos entre las tablas film y actor. Contiene las claves foráneas film_id (que se refiere a film.film_id) y actor_id (que se refiere a actor.actor_id). Estas claves foráneas aseguran que:
-- No se pueda insertar una fila en film_actor si no existe un actor o película correspondiente.
-- No se pueda eliminar una película o un actor si está relacionado con alguna entrada en film_actor, a menos que se permita el borrado en cascada. 

#Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row (assume multiple users, other than root, can connect to MySQL and change this table).
ALTER TABLE employees 
ADD COLUMN lastUpdate DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN lastUpdateUser VARCHAR(255) DEFAULT 'root';

DELIMITER $$

CREATE TRIGGER before_update_employees
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = CURRENT_USER();
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER before_insert_employees
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = CURRENT_USER();
END$$

DELIMITER ;

-- Explicación: El trigger before_update_employees actualiza automáticamente las columnas lastUpdate y lastUpdateUser cada vez que una fila es modificada. El trigger before_insert_employees hace lo mismo al insertar un nuevo registro.
# Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.

SHOW TRIGGERS FROM sakila WHERE `Table` = 'film_text';

DELIMITER $$

CREATE TRIGGER ins_film
AFTER INSERT ON film
FOR EACH ROW
BEGIN
    INSERT INTO film_text (film_id, title, description)
    VALUES (NEW.film_id, NEW.title, NEW.description);
END$$

DELIMITER ;
-- Explicación: Este trigger inserta una nueva fila en film_text cada vez que se agrega una película a la tabla film. La nueva fila en film_text contendrá el film_id, el título y la descripción de la película.

DELIMITER $$

CREATE TRIGGER upd_film
AFTER UPDATE ON film
FOR EACH ROW
BEGIN
    IF (OLD.title != NEW.title) OR (OLD.description != NEW.description) THEN
        UPDATE film_text
        SET title = NEW.title, description = NEW.description
        WHERE film_id = OLD.film_id;
    END IF;
END$$

DELIMITER ;
-- Explicación: Este trigger se activa después de que una fila en film es actualizada. Si el título o la descripción cambian, el trigger actualiza la fila correspondiente en film_text.

DELIMITER $$

CREATE TRIGGER del_film
AFTER DELETE ON film
FOR EACH ROW
BEGIN
    DELETE FROM film_text WHERE film_id = OLD.film_id;
END$$

DELIMITER ;
-- Explicación: Este trigger elimina una fila de film_text cuando la película correspondiente es eliminada de la tabla film.