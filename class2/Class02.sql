CREATE DATABASE IF NOT EXISTS imdb;
USE imdb;
CREATE TABLE film (
    film_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    release_year INT
);

CREATE TABLE actor (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE film_actor (
    actor_id INT,
    film_id INT,
    PRIMARY KEY (actor_id, film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);
ALTER TABLE film ADD COLUMN last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE actor ADD COLUMN last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
-- Insertamos actores
INSERT INTO actor (first_name, last_name) VALUES
('Johnny', 'Depp'),
('Tom', 'Hanks'),
('Leonardo', 'DiCaprio');

-- Insertamos películas
INSERT INTO film (title, description, release_year) VALUES
('Piratas del Caribe', 'una aventura pirata', 2003),
('Forrest Gump', 'Un hombre con discapacidad intelectual logra grandes cosas.', 1994),
('Inception', 'Un ladrón que entra en los sueños de los demás.', 2010);

-- Relacionamos actores con películas
INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1), -- Johnny Depp en Pirates of the Caribbean
(2, 2), -- Tom Hanks en Forrest Gump
(3, 3); -- Leonardo DiCaprio en Inception
-- :))))))))))))))))))))))))))))))))))))))))))))))))))