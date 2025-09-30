use sakila;

-- 1)

select * from address
join city using (city_id)
where not postal_code < "50000";   -- 0.000 sec, porque es una simple

select * from address
where postal_code in (
	select postal_code from address
	join city using (city_id)
    join country using (country_id)
    where country_id = 25
);   -- 0.000 sec, sigue siendo algo simple

select * from address
where postal_code not in (
	select postal_code from address
	join city using (city_id)
    join country using (country_id)
    where country_id = 25 or postal_code not like "3%"
);   -- 0.016 sec, se aplican puertas logicas not dos veces junto con las condiciones me parece que es razonable el tiempo de reaccion.
     -- pasó a 0.000 sec luego de crear el indice para la columna codigo postal. Al tener precargada la columna puede hacer la logica ->  postal_code not like "3%" mas rapido
     -- por lo demas sigue estando igual.


drop index CodigoPostal on address;
create index CodigoPostal on address (postal_code); -- 1.078 sec, por las dudas lo aclaro


-- 2)

select first_name from actor;

select last_name from actor;

-- no veo muchas diferencias. viendo mas a fondo que hizo MySql veo que si ejecuto las dos al mismpo tiempo, sus tipos son index en cambio por separado el first_name no lo tiene. 
-- quiere decir que la columna last_name posee un index 


-- 3)

select film_id, title, description from film
where description like '%action%';

-- MySQL recorre toda la columna, porque LIKE con % no puede usar bien índices.

select film_id, title, description from film_text
where match(description) against('action' in natural language mode);
-- permite búsqueda mucho más rápida y relevante porque usa un indice fulltext


# LIKE busca de forma literal y es lento en textos largos.

# MATCH ... AGAINST usa índices full-text lo qu es mucho más eficiente y permite búsquedas semánticas
