/*
LAB WEEK 3 day 1
Write a query to display for each store its store ID, city, and country.
Write a query to display how much business, in dollars, each store brought in.
What is the average running time of films by category?
Which film categories are longest?
Display the most frequently rented movies in descending order.
List the top five genres in gross revenue in descending order.
Is "Academy Dinosaur" available for rent from Store 1?
*/
#Write a query to display for each store its store ID, city, and country.
#staff= store_id, address_id 
#city = city, city_id, country_id
#country= country_id, country
#address= address_id, city_id 

select a.store_id, c.city_id, d.country_id, d.country
from sakila.staff as a
join sakila.address as b
on a.address_id = b.address_id
join sakila.city as c
on b.city_id = c.city_id
join sakila.country as d
on c.country_id = d.country_id
group by store_id;

#Write a query to display how much business, in dollars, each store brought in.
#staff=store id,staff_id
#payment= staff_id, amount 
select a.store_id, format((sum(b.amount)),'C') as store_amount 
from sakila.staff as a
join sakila.payment as b
on a.staff_id = b.staff_id
group by a.store_id;

#What is the average running time of films by category?
#film = length, film_id
#film_category= film_id, category_id 
select b.category_id, round(avg(a.length),2) as movie_duration
from sakila.film as a
join sakila.film_category as b
on a.film_id = b.film_id
group by b.category_id
order by movie_duration desc; 

#Which film categories are longest? 
select b.category_id, round(avg(a.length),2) as movie_duration
from sakila.film as a
join sakila.film_category as b
on a.film_id = b.film_id
group by b.category_id
order by movie_duration desc
limit 1; 

#Display the most frequently rented movies in descending order.
# rental = rental_id, rental_date,inventory_id,customer_id,return_date,staff_id,last_update
# film = film_id, title
# inventory = inventory_id, film_id

select c.title, a.rental_id, count(a.rental_date)as total_rentals, b.film_id
from sakila.rental as a
left join sakila.inventory as b
on a.inventory_id = b.inventory_id
left join sakila.film as c 
on b.film_id=c.film_id
group by film_id
order by total_rentals desc
limit 10;

#the order of the list changes based on right or left join but only in term of index

#List the top five genres in gross revenue in descending order.
#payment =rental_id,amount a count(a.rental_id), sum(a.amount)
#rental=rental_id, inventory_id b
#inventory=inventory_id, film_id c
#film_category= film_id, category_id  d group by d.category_id 


select count(a.rental_id) as total_rental, sum(a.amount) as gross, d.category_id
from sakila.payment as a
join sakila.rental as b
on a.rental_id = b.rental_id
#from sakila.rental as b
join sakila.inventory as c
on b.inventory_id = c.inventory_id
#from sakila.inventory as c
join sakila.film_category as d
on c.film_id = d.film_id
group by d.category_id
order by gross desc;

#Is "Academy Dinosaur" available for rent from Store 1?
 #a film= title, film_id
 #b inventory= film_id, store_id, inventory_id
 #c rental= inventory_id, return_date is not null 
 
select a.title, a.film_id, b.store_id, c.inventory_id, c.return_date, (count(rental_date)-count(return_date)) as Not_available
from sakila.film as a
join sakila.inventory as b
on a.film_id = b.film_id
join sakila.rental as c
on b.inventory_id = c.inventory_id
where title like 'Academy dinosaur'
group by inventory_id;

#is not null is filtered out 

