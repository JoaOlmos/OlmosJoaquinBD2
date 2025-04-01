use sakila;

#1)
select title, special_features from film
where rating like 'PG-13';

#2)
select rental_duration from film;

#3)
select title, rental_rate, replacement_cost from film
where replacement_cost between 20.00 and 24.00;

#4)
select film.title, category.`name` , film.rating from film_category
inner join film on film_category.film_id = film.film_id
inner join category on film_category.category_id = category.category_id
where special_features like 'Behind the Scenes';

#5)
select first_name, last_name from film_actor
inner join film on film_actor.film_id = film.film_id
inner join actor on film_actor.actor_id = actor.actor_id
where title like 'ZOOLANDER FICTION';

#6)
select city, country from address
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
where address_id = 1;

#7)
select title, rating from film
where rating = rating in(select rating from film);

#8)
select film.title, staff.first_name, staff.last_name from inventory
inner join film on inventory.film_id = film.film_id
inner join store on inventory.store_id = store.store_id
inner join staff on store.manager_staff_id = staff.staff_id
where film.film_id like 2