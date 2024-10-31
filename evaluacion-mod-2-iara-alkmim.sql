/* Ejercicios - Evaluación final Modulo 2 */ 


/* Seleccionar la Base de Datos sakila para utilizar en el ejercicio */ 

USE sakila; 

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. */

SELECT DISTINCT title AS Nombres_Peliculas
FROM film_text;

/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13". */

/* La columna 'rating' esta en la tabla film, por esto vamos a utilizarla */

SELECT title AS Nombres_Peliculas
FROM film
WHERE rating = 'PG-13';
    
    
/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción. */

SELECT title AS Nombres_Peliculas, description AS Descripcion
FROM film_text
WHERE description LIKE '%amazing%';
    
    
/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */

/* La columna 'length' esta en la tabla film, por esto vamos a utilizarla */

SELECT title AS Nombres_Peliculas
FROM film
WHERE length > 120; 
    
    
/* 5. Recupera los nombres de todos los actores. */ 

SELECT CONCAT(first_name," ", last_name) AS Nombre
FROM actor;
    
/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido. */

SELECT first_name AS Nombre, last_name AS Apellido
FROM actor
WHERE last_name = 'Gibson';
    
/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20. */ 

SELECT first_name AS Nombre, last_name AS Apellido
FROM actor
WHERE actor_id BETWEEN 10 AND 20; 
    

/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación. */

SELECT title AS Nombres_Peliculas
FROM film
WHERE rating NOT IN ('PG-13','R');

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con
el recuento. */ 

SELECT  rating, COUNT(title) AS Cantidad_Peliculas
FROM film
GROUP BY rating;
    
/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y
apellido junto con la cantidad de películas alquiladas. */ 


/* verificar si un unico alquiler de una pelicula tiene un solo rentalID */
/*
SELECT c.first_name, c.last_name, f.title, r.rental_id
	FROM customer AS c
    INNER JOIN rental AS r
		USING (customer_id)
	INNER JOIN inventory
		USING (inventory_id)
	INNER JOIN film AS f
		USING (film_id);
*/
        
SELECT c.customer_id AS ID_Cliente, c.first_name AS Nombre, c.last_name AS Apellido, COUNT(r.rental_id) AS Cantidad_pelis_alquiladas
FROM customer AS c
    INNER JOIN rental AS r
	USING (customer_id)
GROUP BY c.first_name, c.last_name, c.customer_id;
    


/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el
recuento de alquileres. */ 

SELECT  c.name AS Nombre_Categoria, COUNT(r.rental_id) AS Cantidad_pelis_alquiladas
FROM category AS c
    INNER JOIN film_category AS fc
    USING (category_id)
	INNER JOIN inventory AS i
	USING (film_id)
	INNER JOIN rental as r
	USING (inventory_id)
GROUP BY c.name;


/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
clasificación junto con el promedio de duración. */ 

/*he hecho el promedio de las pelis por las categorías de las pelis: */
/*
SELECT c.name AS Nombre_categoria, AVG(f.length) AS Promedio_duracion_peli
FROM film AS f
INNER JOIN film_category AS fc
USING (film_id)
INNER JOIN category AS c
USING (category_id)
GROUP BY c.name
*/ 

SELECT f.rating, AVG(f.length) AS Media_dur_pelis
FROM film AS f
GROUP BY f.rating;

/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love". */ 

SELECT first_name AS Nombre, last_name AS Apellido
FROM actor AS a
	INNER JOIN film_actor AS fa
	USING (actor_id)
	INNER JOIN film AS f
	USING (film_id)
WHERE f.title = 'Indian Love';


/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/ 

SELECT title AS Titulo_pelicula
FROM film_text
WHERE description LIKE '%dog%' 
   OR description LIKE '%cat%';


/* 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor. */ 

/* Utilizar un left Join para unir las tablas actor con la film_actor y así identificar los que no están en film_actor. En la primera query puedo verificar los film_id para cada actor y ver si hay algun NULL */

/*SELECT a.first_name AS Nombre, a.last_name AS Apellido, fa.film_id
FROM actor AS a
LEFT JOIN film_actor AS fa 
ON a.actor_id = fa.actor_id*/


SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM actor AS a
	LEFT JOIN film_actor AS fa 
	ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;


/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010. */

SELECT title AS Titulo_peliculas
FROM film AS f
WHERE release_year BETWEEN 2005 AND 2010;

/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family". */ 

/* Query para encontrar la categoria 'Family':*/ 

/*SELECT c.category_id, c.name
	FROM category AS c
	WHERE name = 'Family'; */

SELECT title AS Titulo_peliculas
FROM film_text AS ft
INNER JOIN film_category AS fc
USING (film_id)
WHERE fc.category_id = ( SELECT c.category_id
							FROM category AS c
							WHERE name = 'Family');
                            

/* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. */

SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM actor AS a
INNER JOIN film_actor AS fc
USING (actor_id)
GROUP BY a.first_name, a.last_name
HAVING COUNT(fc.film_id) > 10; 

/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film. */

SELECT title AS Titulo_peliculas
FROM film
WHERE rating = 'R' AND 
	  length > 120;
      
/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el
nombre de la categoría junto con el promedio de duración. */ 


SELECT c.name AS Nombre_categoria, AVG(f.length) AS Promedio_duracion
FROM category AS c
	INNER JOIN film_category AS fc
	USING (category_id)
	INNER JOIN film AS f
	USING (film_id)	
GROUP BY c.name
HAVING AVG(f.length) > 120;

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la
cantidad de películas en las que han actuado. */ 

SELECT CONCAT(first_name," ", last_name) AS Nombre_actor, COUNT(fc.film_id) AS Cantidad_pelis
FROM actor AS a
	INNER JOIN film_actor AS fc
	USING (actor_id)
GROUP BY first_name, last_name
HAVING COUNT(fc.film_id) > 5;


/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. */ 

/*Query para encontrar los rental_ids con una duración superior a 5 días:*/

/* El metodo DATEDIFF hace la diferencia entre fechas de días. Por esto los alquileres que se han hecho y se han devuelto en el mismo día, aparece como 0. */
/*
SELECT rental_id, rental_date, return_date, DATEDIFF(r.return_date, r.rental_date) AS Duracion_alquiler
FROM rental AS r
WHERE DATEDIFF(r.return_date, r.rental_date) > 5;

SELECT rental_id
FROM rental AS r
WHERE DATEDIFF(r.return_date, r.rental_date) > 5;
*/

/* Todas las peliculas con sus rental_ids*/
/*
SELECT f.title, r.rental_id
FROM film AS f
INNER JOIN inventory AS i
USING (film_id)
INNER JOIN rental AS r
USING (inventory_id)
WHERE rental_id IN ( 
					SELECT rental_id
					FROM rental AS r
					WHERE DATEDIFF(r.return_date, r.rental_date) > 5
                    );
*/
 
/* Seleccionar nombres de peliculas unicas que han tenido más de 5 días de alquiler*/ 
 
SELECT DISTINCT f.title
FROM film AS f
INNER JOIN inventory AS i
USING (film_id)
INNER JOIN rental AS r
USING (inventory_id)
WHERE rental_id IN ( 
					SELECT rental_id
					FROM rental AS r
					WHERE DATEDIFF(r.return_date, r.rental_date) > 5
                    );
                    

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego
exclúyelos de la lista de actores. */ 

/* Encontrar las pelis de 'Horror'*/

/*
SELECT *
FROM category
INNER JOIN film_category
USING (category_id)
WHERE name = 'Horror'; 
/*
    
 /* Los actores por peliculas*/
/*
SELECT a.first_name, a.last_name, f.title, f.film_id
	FROM actor AS a
    INNER JOIN film_actor AS fa
    USING (actor_id)
    INNER JOIN film AS f
    USING (film_id); 
    
*/
        
/* Lo actores que han actuados en pelis de 'Horror':*/
/*
SELECT a.actor_id,a.first_name, a.last_name, f.title, f.film_id
	FROM actor AS a
    INNER JOIN film_actor AS fa
    USING (actor_id)
    INNER JOIN film AS f
    USING (film_id)
    WHERE film_id IN (SELECT fc.film_id
						FROM category AS c
						INNER JOIN film_category AS fc
						USING (category_id)
							WHERE name = 'Horror');

*/

/* Lo actores que NO han actuados en pelis de 'Horror' */

SELECT a.first_name AS Nombre, a.last_name AS Apellido
	FROM actor AS a
    WHERE a.actor_id NOT IN (
								SELECT a.actor_id
								FROM actor AS a
								INNER JOIN film_actor AS fa
								USING (actor_id)
								INNER JOIN film AS f
								USING (film_id)
								WHERE film_id IN (
													SELECT fc.film_id
													FROM category AS c
													INNER JOIN film_category AS fc
													USING (category_id)
													WHERE c.name = 'Horror')
                                                    );
                                                                        

/* BONUS */ 


/* 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la
tabla film. */

/* Query para encontrar la categoria 'comedias':*/ 

SELECT c.category_id, c.name
	FROM category AS c
	WHERE name = 'Comedy';

/* Query para encontrar las peliculas que son de la categoria comedy*/
/*
SELECT title AS Titulo_peliculas, length
FROM film AS f
INNER JOIN film_category AS fc
USING (film_id)
WHERE fc.category_id = ( 
							SELECT c.category_id
							FROM category AS c
							WHERE name = 'Comedy');
*/

/* Query para encontrar las peliculas que son de la categoria comedy y mayor que 180 minutos*/

SELECT title AS Titulo_peliculas
FROM film AS f
INNER JOIN film_category AS fc
USING (film_id)
WHERE length >180 AND 
fc.category_id = ( 
				   SELECT c.category_id
				   FROM category AS c
				   WHERE name = 'Comedy'
                   );


/* 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe
mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos. */ 

/*Union de la tabla actor con la de film_actor, para tener nombres y film_ids en un mismo sitio)/*
/*
WITH actor_film AS (
					SELECT a.first_name, a.last_name, a.actor_id, fa.film_id
					FROM actor AS a
					INNER JOIN film_actor AS fa
					ON a.actor_id = fa.actor_id
                    )
SELECT af1.first_name, af1.last_name, af1.film_id, af2.first_name, af2.last_name, af2.film_id
FROM actor_film AS af1
INNER JOIN actor_film AS af2
ON af1.film_id = af2.film_id;
*/

/* Cantidad de peliculas que han hecho juntos:*/

/*La condición af1.actor_id < af2.actor_id se utiliza para evitar duplicados y emparejamientos inversos en los resultados.
Sin esta condición, cada par de actores que trabajaron juntos en una película aparecería dos veces:
una vez como (Actor1, Actor2) y otra vez como (Actor2, Actor1). */

/*La condición af1.actor_id < af2.actor_id no solo evita los emparejamientos duplicados, sino que también asegura que un actor no sea emparejado consigo mismo.
Además, al usar < en lugar de !=, garantizamos que solo se incluya cada combinación única de actores. */

WITH actor_film AS (
					SELECT a.first_name, a.last_name, a.actor_id, fa.film_id
					FROM actor AS a
					INNER JOIN film_actor AS fa
					ON a.actor_id = fa.actor_id
                    )
SELECT af1.first_name AS Nombre_actor_1, af1.last_name AS Apellido_actor_1,
	   af2.first_name AS Nombre_actor_2, af2.last_name AS Apellido_actor_2,
       COUNT(af1.film_id) AS Num_peli_juntos
FROM actor_film AS af1
INNER JOIN actor_film AS af2
ON af1.film_id = af2.film_id 
	AND af1.actor_id < af2.actor_id
GROUP BY af1.first_name, af1.last_name,af2.first_name, af2.last_name;








