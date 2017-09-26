--1a: You need a list of all the actors' first name and last name
SELECT first_name, last_name FROM actor;

--1b: Display the first and last name of each actor in a single column in upper case letters
-- Name the column Actor Name

SELECT 
	upper(first_name) || ' ' || upper(last_name) AS Actor_Name
FROM
	actor;

--2a: You need to find the id, first name, and last name of an actor, of whom you know only the first name of "Joe." What is one query would you use to obtain this information?

SELECT * FROM actor WHERE first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN. Make this case insensitive

SELECT * FROM actor WHERE last_name iLIKE '%GEN%'

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order. Make this case insensitive.

SELECT * FROM actor WHERE last_name iLIKE '%LI%' 
ORDER BY Trim(last_name) ASC, Trim(first_name) ASC;

--2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT
	country_id,
	country
FROM
	country
WHERE
	country_id IN (1, 12, 23);

--3a. Add a middle_name column to the table actor. Specify the appropriate column type

ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(255);

--3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to something that can hold more than varchar.

ALTER TABLE actor
ALTER COLUMN middle_name TYPE name;

-- 3c. Now write a query that would remove the middle_name column.

ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT
 last_name,
 COUNT(last_name)
FROM 
 actor
GROUP BY
last_name;


-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT
 last_name,
 COUNT(last_name)
FROM 
 actor
GROUP BY
 last_name
HAVING count(*) > 1;


--4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor SET first_name = HARPO
WHERE id = 172;

--4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO (Hint: update the record using a unique identifier.)

IF first_name = HARPO THEN
	UPDATE actor SET first_name = GROUCHO
	WHERE id = 172
ELSE 
	UPDATE actor SET first_name = MUCHO GROUCHO
	WHERE id = 172
END IF;

--5a: What’s the difference between a left join and a right join. 
--What about an inner join and an outer join? 
	--Inner Join: Returns records that have matching values in both tables
	    -- You can join the Actor ID and Actor Name based on a common Actor ID in both tables from film_actor / actor
	--Left (Outer) Join: Returns all records from the left table, and the matched records from the right table
	    -- You can join a full table like actor and LEFT JOIN film_id on actor id to add on the remaining information from the second table
--When would you use rank? 
	--Rank: The rank function produces a numerical rank within the current row's partition each distinct ORDER BY value.
	-- An example would be the ranking for films over their film language.
--What about dense_rank?
	-- dense_rank computes the rank of a row in an ordered group of rows and returns the rank as a number. It is a rank with no gaps. An example would be the same for rank, but the dense_rank would not skip over the rank numbers and would be consecutive for film language.
--When would you use a subquery in a select? 
	-- A subquery is a query within a query so that you can select information otherwise impossible with just a single query. This would be selecting the film_id and actor_id from the actors table and selecting information from the film table to find the actors for a single film. 
--When would you use a right join?
	-- When you want to get a complete set of records from the right with the matching records on the left. For example if you wanted to right a payment table on the left with the customer table on the right, but join in on the customer number. You would get the full customer table with the mathcing payments from the first table.
--When would you use an inner join over an outer join?
	-- You would use an inner join where there must be at least some matching data that are being compared for matching/overallping data. This will return the combined data into one new table. An outer join returns a set of records that include what an inner join would return but includes other rows for no corresponding match is found for the other table. An example would be two tables for a produce (potato, avocado, kiwis) and price, the other with the produce and quantity. If you inner join them, it will match the price and quantity based on the produce for information that exists. For outer join, if the produce does not exist in one table, it will still join the produce in the final table and have the NULL result for the nonexistent data. 
--What’s the difference between a left outer and a left join
	-- Left Outer Join will return all the data in the first table and the corresponding data from the second table. However, the left outer join differes from the left join in the sense that it will have null where there are no values. An example would be when you match the film_id with the title from the film tableand the inventory_id is NULL when LEFT JOIN on the inventory based on film_id. 
--When would you use a group by?
	-- group by will divide rows into groups and you can apply an aggregate function such as sum and count to get the number of items per group. For example, per customer id you can find the total sum amount of how much they made from the payment table. 
--Describe how you would do data reformatting
	-- For data reformatting, you can do ALTER TABLE and ALTER COLUMN to change the data type of the column. This would be useful for changing the column to hold more characters (VARCHAR vs. name) and to change from a string like 1907 (year) to an integer. 
--When would you use a with clause?
	-- A with clause can help break down complicated queries into simpler forms which are readable. It is useful when subqueries are executed multiple times. For example, you can use the WITH CLAUSE to select the information AS CTE for data from company name, age, address, salary. This will select the data that you want and put it into as another table/variable. 
--bonus: When would you use a self join?


-- 6a. Use a JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT
 staff.first_name,
 staff.last_name,
 staff.address_id,
 address_id,
 address
FROM
 staff
LEFT JOIN address ON staff.address_id = address.address_id


-- 6b. Use a JOIN to display the total amount rung up by each staff member in January of 2007. Use tables staff and payment.

SELECT
 staff.first_name,
 staff.last_name,
 staff.staff_id,
 payment_p2007_01.staff_id,
 SUM(payment_p2007_01.amount)
FROM payment_p2007_01
LEFT JOIN staff
ON payment_p2007_01.staff_id = staff.staff_id
GROUP BY staff.first_name, staff.last_name, staff.staff_id, payment_p2007_01.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT film.title, COUNT(film_actor.film_id) 
FROM film INNER JOIN film_actor ON (film.film_id = film_actor.film_id)
GROUP BY film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT
 film.title, film.film_id, COUNT(inventory.film_id)
FROM 
 film INNER JOIN inventory ON (film.film_id = inventory.film_id)
GROUP BY
 film.title, film.film_id
HAVING film.film_id = 439;

--total number of copies = 6

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT p.customer_id, c.first_name, c.last_name, SUM(p.amount)
FROM payment p
LEFT JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id, c.first_name, c.last_name
ORDER BY last_name ASC;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. display the titles of movies starting with the letters K and Q whose language is English.

SELECT film.title
FROM film
WHERE film.title LIKE 'K%' OR WHERE film.title LIKE 'Q%'
HAVING language_id = 1;


-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

--SELECT film_actor.film_id, film_actor.film_id
--FROM film_actor
--WHERE film_actor.film_id IN
   --(SELECT film.film_id
    --FROM film
    --WHERE film.title = 17);

SELECT *
FROM actor
WHERE actor_id =
    (SELECT actor_id 
     FROM film_actor 
     WHERE film_id = 17);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.



-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as a family film.



-- Now we mentioned family film, but there is no family film category. There’s a category that resembles that. In the real world nothing will be exact.
-- 7e. Display the most frequently rented movies in descending order.

SELECT film_id, title, rental_duration from film
GROUP BY film_id
ORDER BY rental_duration DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.



-- 7g. Write a query to display for each store its store ID, city, and country.


-- 7h. List the top five genres in gross revenue in descending order. 


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 


-- 8b. How would you display the view that you created in 8a?


-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_five_genres;