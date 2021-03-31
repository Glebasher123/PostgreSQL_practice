SELECT count( * ) FROM ticketss;
SELECT count( * ) FROM ticketss WHERE passenger_name LIKE '% %';
SELECT count( * ) FROM ticketss WHERE passenger_name LIKE '% % %'; -- не просчитывает пробелы
SELECT count( * ) FROM ticketss WHERE passenger_name LIKE '% %%';
--1

SELECT passenger_name
FROM ticketss
WHERE passenger_name LIKE '___ %';

SELECT passenger_name
FROM ticketss
WHERE passenger_name LIKE '% _____'; -- шаблон для выбора с фамилиями, состоящими из пяти букв
--2

--+ 3
--BETWEEN SYMMETRIC --4
--+ 5

select * 
from aircrafts a
join routes r on a.aircraft_code = r.aircraft_code
where model = 'Боинг 737-300' --6

SELECT LEAST(departure_city, arrival_city), GREATEST(departure_city, arrival_city)
FROM routes r
JOIN aircrafts a ON r.aircraft_code = a.aircraft_code
WHERE a.model = 'Боинг 737-300'
GROUP BY 1,2
ORDER BY 1,2 --7


SELECT a.aircraft_code AS a_code,
a.model,
r.aircraft_code AS r_code,
count( r.aircraft_code ) AS num_routes
FROM aircrafts a
FULL JOIN routes r ON r.aircraft_code = a.aircraft_code
GROUP BY 1, 2, 3
ORDER BY 4 DESC; --8

SELECT departure_city, arrival_city, count( * )
FROM routes
WHERE departure_city = 'Москва' AND arrival_city = 'Санкт-Петербург'
GROUP BY departure_city, arrival_city --9


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

++ rank() --15