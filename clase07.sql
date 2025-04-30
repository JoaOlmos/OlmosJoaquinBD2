
--  Query 1

SELECT f.title, f.rating
FROM (
    SELECT title, rating, length
    FROM film
) AS f,
(
    SELECT MIN(length) AS min_length
    FROM film
) AS m
WHERE f.length = m.min_length;



--  Query 2

SELECT f.title
FROM (
    SELECT title, length
    FROM film
) AS f,
(
    SELECT length
    FROM (
        SELECT length
        FROM film
        GROUP BY length
        HAVING COUNT(*) = 1
    ) AS unique_lengths,
    (
        SELECT MIN(length) AS min_length
        FROM film
    ) AS m
    WHERE unique_lengths.length = m.min_length
) AS only_min_unique
WHERE f.length = only_min_unique.length;



-- Query 3 con min

SELECT customer_id,
       first_name,
       last_name,
       (SELECT MIN(amount)
          FROM payment
         WHERE customer.customer_id = payment.customer_id) AS lowest_payment
FROM customer
ORDER BY customer_id;

    c.customer_id;
--- con all
SELECT customer_id,
       first_name,
       last_name,
       (SELECT DISTINCT amount
          FROM payment
         WHERE customer.customer_id = payment.customer_id
           AND amount <= ALL (
               SELECT amount
               FROM payment
               WHERE customer.customer_id = payment.customer_id
           )
       ) AS lowest_payment
FROM customer
ORDER BY customer_id;

--  Query 4 

SELECT customer_id,
       first_name,
       last_name,
       (SELECT DISTINCT amount
          FROM payment
         WHERE customer.customer_id = payment.customer_id
           AND amount <= ALL (
               SELECT amount
               FROM payment
               WHERE customer.customer_id = payment.customer_id
           )
       ) AS min_payment,
       (SELECT DISTINCT amount
          FROM payment
         WHERE customer.customer_id = payment.customer_id
           AND amount >= ALL (
               SELECT amount
               FROM payment
               WHERE customer.customer_id = payment.customer_id
           )
       ) AS max_payment
FROM customer
ORDER BY customer_id;

