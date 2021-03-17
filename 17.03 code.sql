SELECT LEAST('applds', 'apples', 'applcs')
select * from routes
select * from aircrafts

SELECT departure_city, arrival_city, count (*) as modelscount
FROM routes
group by departure_city, arrival_city

insert into aircrafts (aircraft_code, model, range) values (432, 'Боинг 737-300', 5400)

---ind task---
SELECT LEAST(departure_city, arrival_city), GREATEST(departure_city, arrival_city)
FROM routes r
JOIN aircrafts a ON r.aircraft_code = a.aircraft_code
WHERE a.model = 'Боинг 737-300'
GROUP BY 1,2
ORDER BY 1,2 --7

SELECT LEAST(departure_city, arrival_city), GREATEST(departure_city, arrival_city), count (*) as modelscount
FROM routes
GROUP BY 1,2
ORDER BY 3 DESC
--10

SELECT departure_city, arrival_city, array_length(days_of_week, 1)
FROM routes
WHERE departure_city = 'Москва'
GROUP BY departure_city, arrival_city, 3
ORDER BY 3 DESC
--11

SELECT unnest( days_of_week ) AS day_of_week,
count( * ) AS num_flights
FROM routes
WHERE departure_city = 'Москва'
GROUP BY day_of_week
ORDER BY day_of_week;

SELECT flight_no, unnest( days_of_week ) AS day_of_week
FROM routes
WHERE departure_city = 'Москва'
ORDER BY flight_no;
-- unnest - функция, которая из массива представляет строки с данными

SELECT dw.name_of_day, count( * ) AS num_flights
FROM 
(
SELECT unnest( days_of_week ) AS num_of_day
FROM routes
WHERE departure_city = 'Москва'
) 
AS r,
unnest('{ "Пн.", "Вт.", "Ср.", "Чт.", "Пт.", "Ср.", "Вс."}'::text[]) 
with ordinality 
as dw( name_of_day , num_of_day)
WHERE r.num_of_day = dw.num_of_day
GROUP BY r.num_of_day, dw.name_of_day
ORDER BY r.num_of_day;

-- 12

SELECT f.departure_city, f.arrival_city,
max( tf.amount ), min( tf.amount )
FROM flights_v f
JOIN ticket_flights tf ON f.flight_id = tf.flight_id
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT f.departure_city, f.arrival_city, tf.amount,
max( tf.amount ), min( tf.amount )
FROM flights_v f
JOIN ticket_flights tf ON f.flight_id = tf.flight_id
GROUP BY 1, 2, 3
HAVING amount IS NULL
ORDER BY 3;
--13

SELECT left( passenger_name, strpos( passenger_name, ' ' ) - 1 )
AS firstname, count( * )
FROM tickets
GROUP BY 1
ORDER BY 2 DESC;

SELECT split_part(passenger_name, ' ', 2)
AS lastname, count( * )
FROM ticketss
GROUP BY 1
ORDER BY 2 DESC;
--14

----- tasks sql-ex.ru -----

select distinct maker, speed
from product
join laptop on product.model = laptop.model
where hd >= 10 --6(2) ok

SELECT a.model, price 
FROM (SELECT model, price 
 FROM PC 
 UNION
 SELECT model, price 
  FROM Laptop
 UNION
 SELECT model, price 
 FROM Printer
 ) AS a JOIN 
 Product p ON a.model = p.model
WHERE p.maker = 'B'; -- 7(2)

