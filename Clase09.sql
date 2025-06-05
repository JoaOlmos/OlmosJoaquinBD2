USE sakila;

# Get the amount of cities per country in the database. Sort them by country, country_id.
SELECT 
    country,
    country_id,
    (
        SELECT COUNT(*) 
        FROM city 
        WHERE city.country_id = country.country_id
    ) AS city_count
FROM country
ORDER BY country, country_id;

# Get the amount of cities per country in the database. 
# Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest
SELECT 
    country,
    (
        SELECT COUNT(*) 
        FROM city 
        WHERE city.country_id = country.country_id
    ) AS city_count
FROM country
WHERE (
    SELECT COUNT(*) 
    FROM city 
    WHERE city.country_id = country.country_id
) > 10
ORDER BY city_count DESC;

#Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films.
#Show the ones who spent more money first .
SELECT 
    c.first_name,
    c.last_name,
    a.address,
    (
        SELECT COUNT(*) 
        FROM rental r 
        WHERE r.customer_id = c.customer_id
    ) AS total_rentals,
    (
        SELECT SUM(p.amount) 
        FROM payment p 
        WHERE p.customer_id = c.customer_id
    ) AS total_spent
FROM customer c
JOIN address a ON c.address_id = a.address_id
ORDER BY total_spent DESC;

#Which film categories have the larger film duration (comparing average)?
#        Order by average in descending order
SELECT 
    category_id,
    (SELECT name FROM category c WHERE c.category_id = fc.category_id) AS category_name,
    (SELECT AVG(length) 
     FROM film f 
     WHERE f.film_id IN 
        (SELECT film_id FROM film_category WHERE category_id = fc.category_id)
    ) AS avg_duration
FROM 
    film_category fc
GROUP BY 
    category_id
ORDER BY 
    avg_duration DESC;


# Show sales per film rating
SELECT 
    rating,
    (SELECT SUM(p.amount) 
     FROM payment p 
     WHERE p.rental_id IN (
         SELECT rental_id 
         FROM rental 
         WHERE inventory_id IN (
             SELECT inventory_id 
             FROM inventory 
             WHERE film_id IN (
                 SELECT film_id 
                 FROM film f2 
                 WHERE f2.rating = f.rating
             )
         )
     )
    ) AS total_sales
FROM 
    film f
GROUP BY 
    rating
ORDER BY 
    total_sales DESC;
