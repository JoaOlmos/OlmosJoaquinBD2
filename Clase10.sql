use sakila;
-- Find all the film titles that are not in the inventory.
select distinct title from film f
left join inventory i using (film_id)
where i.film_id is null;

-- Find all the films that are in the inventory but were never rented.
select title, i.inventory_id from inventory i
join film using(film_id)
left join rental r using(inventory_id)
where r.inventory_id is null;

-- generar un reporte que me de cuando la peli fue alquilada y devuelta a cada ujno de esos clientes
select first_name, last_name, c.store_id, title from customer c
join rental using (customer_id)
join inventory using(inventory_id)
join film using(film_id)
order by store_id, last_name asc;

-- Show sales per store (money of rented films)
-- show store's city, country, manager info and total sales (money)
-- (optional) Use concat to show city and country and manager first and last name   <--- decido hacerlo

select sum(amount) as TOTALxTIENDA, concat(country.country," ", city.city) as Direccion, concat(s.first_name," ", s.last_name) as 'Manager Encargado' from payment p
join customer c using(customer_id)
join store using(store_id)
join address on store.address_id = address.address_id
join city using(city_id)
join country using(country_id)
join staff s on store.manager_staff_id = s.staff_id
group by c.store_id;

-- Which actor has appeared in the most films?
select actor_id, count(*) as num_pelis, concat(first_name," " ,last_name) as Actor from actor 
join film_actor using (actor_id)
group by actor_id
order by num_pelis desc
limit 1