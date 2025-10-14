-- 1) Create a user data_analyst
DROP USER 'data_analyst'@'localhost';
CREATE USER 'data_analyst'@'localhost';

-- 2) Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.

GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';

FLUSH PRIVILEGES;

-- 3) Login with this user and try to create a table. Show the result of that operation.

-- mysql -u data_analyst -p

-- al intentar crear una tabla salta lo siguiente
-- ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'tabla_pruebas'
-- no mpuedo usar create porque no tengo permisos

-- 4) Try to update a title of a film. Write the update script.

USE sakila;

UPDATE film
SET title = 'The Matrix Reloaded'
WHERE title = 'The Matrix';

-- Query OK, 1 row affected (0.01 sec)

-- 5) With root or any admin user revoke the UPDATE permission. Write the command
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';
FLUSH PRIVILEGES;
-- todo perfecto
-- 6) Login again with data_analyst and try again the update done in step 4. Show the result.

-- ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'