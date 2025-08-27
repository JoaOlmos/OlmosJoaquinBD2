USE sakila;
#1)
INSERT INTO staff (first_name, last_name, address_id, store_id, username, email, active, last_update)
VALUES ('Carlos', 'Pérez', 5, 1, 'cperez', NULL, 1, NOW());

-- la fila se inserta correctamente, osea que la columna email permite valores null
SELECT * FROM staff;

-- SET SQL_SAFE_UPDATES = 1;
#2)
UPDATE staff SET staff_id = staff_id - 20;
-- no deja porque hay un error para numeros menor a 20, pero supongo que a todas las filas les resta 20. Probe con 1, y si, le resta ese valor a todas las filas
UPDATE staff SET staff_id = staff_id + 20;
-- suma 20 a los ids de staff

-- delete from staff where staff_id >=2

#3)
ALTER TABLE staff
ADD COLUMN age INT CHECK (age BETWEEN 16 AND 70);

#4)
-- film tiene film_id (PK).

-- actor tiene actor_id (PK).

-- film_actor es tabla intermedia (N:M).

-- FK (film_id) → film(film_id)

-- FK (actor_id) → actor(actor_id)

-- PK compuesta (film_id, actor_id) asegura que un actor no se repita dos veces en la misma película.

#5)

ALTER TABLE staff
ADD COLUMN lastUpdateUser VARCHAR(50);

DELIMITER $$

CREATE TRIGGER staff_before_insert
BEFORE INSERT ON staff
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = USER();
END$$

CREATE TRIGGER staff_before_update
BEFORE UPDATE ON staff
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = USER();
END$$

DELIMITER ;


#6)
SHOW TRIGGERS LIKE 'film%';

-- ins_film → Se ejecuta cuando insertás en film.

-- Inserta un registro en film_text con film_id, title, description.

-- upd_film → Se ejecuta cuando actualizás film.

-- Actualiza el title y description en film_text. 

-- del_film → Se ejecuta cuando borrás un film.

-- Elimina el registro correspondiente en film_text.


