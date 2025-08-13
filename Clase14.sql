use sakila;

#1
SELECT CONCAT(c.first_name, ' ', c.last_name) AS nombre_apellido, a.address, ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
WHERE ci.country_id = (SELECT country_id FROM country WHERE country = 'Argentina');

#2
SELECT 
    f.title,
    l.name AS idioma,
    CASE
        WHEN f.rating = 'G' THEN 'Publico general'
        WHEN f.rating = 'PG' THEN 'Se recomienda la supervisión de los padres'
        WHEN f.rating = 'PG-13' THEN 'Se recomienda a los padres'
        WHEN f.rating = 'R' THEN 'Restringido'
        WHEN f.rating = 'NC-17' THEN 'Solo adultos'
    END AS calificacion
FROM
    film f
        JOIN
    language l ON f.language_id = l.language_id;

#3
SET @actor_name = "penelope guiness";  -- Reemplaza con el nombre del actor

SELECT f.title, f.release_year
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN 
actor a ON fa.actor_id = a.actor_id
WHERE 
    LOWER(CONCAT(a.first_name, ' ', a.last_name)) LIKE LOWER(CONCAT('%', @actor_name, '%'));

#4
SELECT f.title,CONCAT(c.first_name, ' ', c.last_name) AS nombre_apellido,
    CASE 
        WHEN r.return_date IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS returned
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) IN (5, 6);

#5

#Ambas son funciones utilizadas para cambiar el tipo de datos.
#Cast convierrte un valor de un tipo de dato a otro y convert es similar pero permite especificar el formato de conversión.
SELECT CAST(rental_date AS DATE) AS rental_only_date
FROM rental;

SELECT CONVERT(rental_date, DATE) AS rental_only_date
FROM rental;
#Cast es estandar y se utiliza en varios sistemas. 
-- Convert es específico de SQL Server y MySQL

#6
#Nvl: Se utiliza para reemplazar valores nulos (no soportado por mysql)
#ISNULL: niega la condicon null 0 --> 1 y de 1 --> 0
#IFNULL: Devuelve el primer argumento si no es nulo, sino, devuelve el segundo
#COALESCE: Devuelve el primer valor no nulo en la lista de argumentos
