-- 1)
delimiter //

create function get_film_copies(
    p_film_identifier varchar(100),
    p_store_id int
)
returns int
deterministic
begin
    declare v_film_id int;
    declare v_count int;

    -- si el parámetro es numérico, se usa como id; si no, se busca por título
    if p_film_identifier regexp '^[0-9]+$' then
        set v_film_id = p_film_identifier;
    else
        select film_id into v_film_id
        from film
        where title = p_film_identifier
        limit 1;
    end if;

    select count(*) into v_count
    from inventory
    where film_id = v_film_id and store_id = p_store_id;

    return v_count;
end //

delimiter ;

-- ejemplo de uso:
select get_film_copies('ACADEMY DINOSAUR', 1);
select get_film_copies('1', 1);

--2)

delimiter //

create procedure get_customers_by_country(
    in p_country_name varchar(50),
    out p_customer_list text
)
begin
    declare done int default 0;
    declare v_first varchar(45);
    declare v_last varchar(45);
    declare v_fullname varchar(100);
    declare v_list text default '';

    declare cur cursor for
        select c.first_name, c.last_name
        from customer c
        join address a on c.address_id = a.address_id
        join city ci on a.city_id = ci.city_id
        join country co on ci.country_id = co.country_id
        where co.country = p_country_name;

    declare continue handler for not found set done = 1;

    open cur;

    read_loop: loop
        fetch cur into v_first, v_last;
        if done then
            leave read_loop;
        end if;

        set v_fullname = concat(v_first, ' ', v_last);

        if v_list = '' then
            set v_list = v_fullname;
        else
            set v_list = concat(v_list, ';', v_fullname);
        end if;
    end loop;

    close cur;

    set p_customer_list = v_list;
end //

delimiter ;

-- ejemplo de uso:
call get_customers_by_country('Canada', @lista);
select @lista;


--3)

create function inventory_in_stock(p_inventory_id int)
returns boolean
reads sql data
begin
    declare v_rentals int;
    declare v_out int;

    select count(*) into v_rentals
    from rental
    where inventory_id = p_inventory_id;

    if v_rentals = 0 then
        return true;
    end if;

    select count(*) into v_out
    from rental
    where inventory_id = p_inventory_id
      and return_date is null;

    if v_out > 0 then
        return false;
    else
        return true;
    end if;
end;
