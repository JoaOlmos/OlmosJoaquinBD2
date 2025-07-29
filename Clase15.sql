use sakila;

-- pide bastantes columnas fijate en el github
create or replace view list_of_customers as
	select customer_id, concat(first_name," ",last_name) as "customer full name", address, postal_code as "zip code", phone,  city, country, IF(active = 1, 'active', 'inactive') AS status, store_id  from customer c
    join address using (address_id)
    join city using (city_id)
    join country using (country_id);
select * from list_of_customers;

-- Create a view named film_details, it should contain the following columns: 
-- film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. 
-- Hint use GROUP_CONCAT
CREATE OR REPLACE VIEW film_details AS
SELECT 
    f.film_id,
    f.title,
    f.description,
    
    -- para tener categoria
    (
        SELECT c.name 
        FROM category c
        JOIN film_category fc ON c.category_id = fc.category_id
        WHERE fc.film_id = f.film_id
        LIMIT 1
    ) AS category,
    
    f.rental_rate AS price,
    f.length,
    f.rating,
    
    -- para tener los actores
    (
        SELECT GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) ORDER BY a.last_name SEPARATOR ', ')
        FROM actor a
        JOIN film_actor fa ON a.actor_id = fa.actor_id
        WHERE fa.film_id = f.film_id
    ) AS actors

FROM film f;

select * from film_details;

-- Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
Create or replace view sales_by_film_category as
	SELECT
	  c.name AS category,
	  COUNT(r.rental_id) AS total_rental
	FROM category c
	JOIN film_category fc ON c.category_id = fc.category_id
	JOIN film f ON fc.film_id = f.film_id
	JOIN inventory i ON f.film_id = i.film_id
	JOIN rental r ON i.inventory_id = r.inventory_id
	GROUP BY c.name;


select * from sales_by_film_category;

-- Create a view called actor_information where it should return,
-- actor id, first name, last name and the amount of films he/she acted on.
Create or replace view actor_information as
	select actor_id, first_name, last_name, count(f.film_id) cant from actor
    join film_actor f using(actor_id)
    group by actor_id
    order by cant asc;
    
select * from actor_information

-- Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, 
-- take some time and decompose each part and give an explanation for each.

-- primero se carga la tabla 'actor' y se une con la tabla 'film_actor' 
-- realizando el producto cruz luego se filtra con 'using' las filas que cumplan la condicion donde 
-- 'film_actor.actor_id = actor.actor_id'. Despues se agrupan las filas por 'actor_id' y se ejecuta el select
-- donde se muestran solo las columnas 'actor_id, first_name, last_name' y se calcula la agregacion que 
-- cuenta cada pelicula en la que actuo el actor. Esto ultimo es aplicado a cada grupo generado.
-- Y por ultimo se ordenan las filas de menor a mayor segun la columna 'count' renombrado a cant


-- Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.

-- list_of_customers se usa para listar todo los clientes registrados en las tiendas. Es usada para saber quienes son los clientes activos.
-- film_details se usa para listar todas los detalles de peliculas. Usada para mostrarse en la seleccion para elegir la pelicula
-- sales_by_film_category se usa para ver a todas las peliculas listadas por categoria. Usada para ver cuales son las categorias mas vendidas
-- actor_information se usa para ver la info de cada actor y en cuantas peliculas actuo. 
