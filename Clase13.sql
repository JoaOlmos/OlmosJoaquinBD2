USE sakila;
#1
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
SELECT 1,'Pepe','Paez','pepemecanico@example.com',
		(
		SELECT address_id FROM address
        JOIN city USING(city_id)
		WHERE country_id = (
			SELECT country_id FROM country 
			WHERE country = 'United States'
		) 
		ORDER BY address_id DESC 
        LIMIT 1
		),
    1,
    NOW();

#2

-- Ejemplo con película 'ACADEMY DINOSAUR'
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
  NOW(),
  (
    SELECT MAX(inventory_id)
    FROM inventory
    WHERE film_id = (
      SELECT film_id FROM film WHERE title = 'ACADEMY DINOSAUR'
    )
  ),
  (
    SELECT MAX(customer_id) FROM customer
  ),
  (
    SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1
  )
);


#3

UPDATE film SET release_year = 2001 WHERE rating = 'G';
UPDATE film SET release_year = 2002 WHERE rating = 'PG';
UPDATE film SET release_year = 2003 WHERE rating = 'PG-13';
UPDATE film SET release_year = 2004 WHERE rating = 'R';
UPDATE film SET release_year = 2005 WHERE rating = 'NC-17';


#4
UPDATE rental
SET return_date = NOW()
WHERE rental_id = (
  SELECT rental_id
  FROM rental
  WHERE return_date IS NULL
  ORDER BY rental_date DESC
  LIMIT 1
);

#5
-- intento borrar filas de la tabla film pero no puedo porque al mismo tiempo se hace referencia a esa misma tabla en una subconsulta del from
DELETE FROM film WHERE film_id = (
  SELECT film_id FROM film WHERE title = 'ACADEMY DINOSAUR'
);
-- una de las formas correctas es asi:
-- guardo el film_id a eliminar
SET @film_id := (SELECT film_id FROM film WHERE title = 'ACADEMY DINOSAUR');

-- eliminar desde tablas dependientes
DELETE FROM payment
WHERE rental_id IN (
  SELECT rental_id FROM rental
  WHERE inventory_id IN (
    SELECT inventory_id FROM inventory WHERE film_id = @film_id
  )
);

DELETE FROM rental
WHERE inventory_id IN (
  SELECT inventory_id FROM inventory WHERE film_id = @film_id
);

DELETE FROM inventory WHERE film_id = @film_id;
DELETE FROM film_actor WHERE film_id = @film_id;
DELETE FROM film_category WHERE film_id = @film_id;

-- Finalmente
DELETE FROM film WHERE film_id = @film_id;

#6

SELECT inventory_id
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'ACADEMY DINOSAUR')
AND inventory_id NOT IN (SELECT inventory_id FROM rental WHERE return_date IS NULL)
LIMIT 1;

INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
    NOW(),
    (SELECT inventory_id
    FROM inventory
    WHERE film_id = (SELECT film_id FROM film WHERE title = 'ACADEMY DINOSAUR')
    AND inventory_id NOT IN (SELECT inventory_id FROM rental WHERE return_date IS NULL)
    LIMIT 1),
    (SELECT customer_id FROM customer WHERE first_name = 'Pepe' AND last_name = 'Paez' LIMIT 1),
    (SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1)
);

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (
    (SELECT customer_id FROM customer WHERE first_name = 'Pepe' AND last_name = 'Paez' LIMIT 1),
    (SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1),
    (SELECT rental_id FROM rental ORDER BY rental_id DESC LIMIT 1),
    2.99,
    NOW()
);

