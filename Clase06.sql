USE sakila;
#1) Lista de todos los actores que comparten apellido
SELECT a1.first_name, a1.last_name
FROM actor a1
WHERE EXISTS (
    SELECT 1
    FROM actor a2
    WHERE a1.actor_id <> a2.actor_id
    AND a1.last_name = a2.last_name
)
ORDER BY a1.last_name, a1.first_name;
#2) Encontrar actores que no laburen en pelis
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor fa
    WHERE fa.actor_id = a.actor_id
);
#3) Encontrar clientes que rentaron solo 1 peli
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE (
    SELECT COUNT(*)
    FROM rental r
    WHERE r.customer_id = c.customer_id
) = 1;
#4) Encontrar clientes que rentaron mas de 1 peli
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE (
    SELECT COUNT(*)
    FROM rental r
    WHERE r.customer_id = c.customer_id
) > 1;
#5) Listar a los actores que actuaron en 'BETRAYED REAR' o en 'CATCH AMISTAD'
SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE EXISTS (
    SELECT 1
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE fa.actor_id = a.actor_id
    AND f.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
)
ORDER BY a.last_name, a.first_name;
#6) Listar a los actores que actuaron en 'BETRAYED REAR' pero no en 'CATCH AMISTAD'
SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE EXISTS (
    SELECT 1
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE fa.actor_id = a.actor_id
    AND f.title = 'BETRAYED REAR'
)
AND NOT EXISTS (
    SELECT 1
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE fa.actor_id = a.actor_id
    AND f.title = 'CATCH AMISTAD'
)
ORDER BY a.last_name, a.first_name;
#7) Listar a los actores que actuaron en 'BETRAYED REAR' y en 'CATCH AMISTAD'
SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE EXISTS (
    SELECT 1
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE fa.actor_id = a.actor_id
    AND f.title = 'BETRAYED REAR'
)
AND EXISTS (
    SELECT 1
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE fa.actor_id = a.actor_id
    AND f.title = 'CATCH AMISTAD'
)
ORDER BY a.last_name, a.first_name;
#8) Listar a los actores que no actuaron en 'BETRAYED REAR' o en 'CATCH AMISTAD'
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE fa.actor_id = a.actor_id
    AND f.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
)
ORDER BY a.last_name, a.first_name;