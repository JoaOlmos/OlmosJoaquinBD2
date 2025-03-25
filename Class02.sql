DROP DATABASE IF EXISTS imdb;
CREATE DATABASE imdb;
USE imdb;

CREATE TABLE IF NOT EXISTS films (
    film_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(30) NOT NULL,
    description VARCHAR(100) NOT NULL,
    release_year YEAR NOT NULL, 
    
    PRIMARY KEY (film_id)
);

CREATE TABLE IF NOT EXISTS actor (
    actor_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(15) NOT NULL,
    last_name VARCHAR(15) NOT NULL,
    
    PRIMARY KEY (actor_id)
);

CREATE TABLE IF NOT EXISTS film_actor (
    actor_id INT NOT NULL,
    film_id INT NOT NULL,
    
    PRIMARY KEY (actor_id, film_id),
    
    CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) 
        REFERENCES actor(actor_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) 
        REFERENCES films(film_id) ON DELETE CASCADE ON UPDATE CASCADE
);
