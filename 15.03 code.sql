SELECT a.aircraft_code, a.model, s.seat_no
FROM seats AS s
JOIN aircrafts AS a
ON s.aircraft_code = a.aircraft_code
WHERE a.model ~ '^Сессна'
ORDER BY s.seat_no;

SELECT * FROM seats WHERE aircraft_code = 'CN1';

SELECT s.seat_no
FROM seats s
JOIN aircrafts a ON s.aircraft_code = a.aircraft_code
WHERE a.model ~ '^Сессна'
ORDER BY s.seat_no;

SELECT a.aircraft_code, a.model, s.seat_no
FROM seats s, aircrafts a
WHERE s.aircraft_code = a.aircraft_code
AND a.model ~ '^Сессна'
ORDER BY s.seat_no;

CREATE OR REPLACE VIEW flights_v AS
SELECT f.flight_id,
f.flight_no,
f.scheduled_departure,
timezone( dep.timezone, f.scheduled_departure )
AS scheduled_departure_local,
f.scheduled_arrival,
timezone( arr.timezone, f.scheduled_arrival )
AS scheduled_arrival_local,
f.scheduled_arrival - f.scheduled_departure
AS scheduled_duration,
f.departure_airport,
dep.airport_name AS departure_airport_name,
dep.city AS departure_city,
f.arrival_airport,
arr.airport_name AS arrival_airport_name,
arr.city AS arrival_city,
f.status,
f.aircraft_code,
f.actual_departure,
timezone( dep.timezone, f.actual_departure )
AS actual_departure_local,
f.actual_arrival,
timezone( arr.timezone, f.actual_arrival )
AS actual_arrival_local,
f.actual_arrival - f.actual_departure AS actual_duration
FROM flights f,
airports dep,
airports arr
WHERE f.departure_airport = dep.airport_code
AND f.arrival_airport = arr.airport_code;

SELECT count( * )
FROM airports a1, airports a2
WHERE a1.city <> a2.city;

SELECT count( * )
FROM airports a1
JOIN airports a2 ON a1.city <> a2.city;

SELECT count( * )
FROM airports a1 CROSS JOIN airports a2
WHERE a1.city <> a2.city;

SELECT r.aircraft_code, a.model, count( * ) AS num_routes
FROM routes r
JOIN aircrafts a ON r.aircraft_code = a.aircraft_code
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT a.aircraft_code AS a_code,
a.model,
r.aircraft_code AS r_code,
count( r.aircraft_code ) AS num_routes
FROM aircrafts a
LEFT OUTER JOIN routes r ON r.aircraft_code = a.aircraft_code
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

SELECT count( * )
FROM ( ticket_flights t
JOIN flights f ON t.flight_id = f.flight_id
)
LEFT OUTER JOIN boarding_passes b
ON t.ticket_no = b.ticket_no AND t.flight_id = b.flight_id
WHERE f.actual_departure IS NOT NULL AND b.flight_id IS NULL;

SELECT f.flight_no,
f.scheduled_departure,
f.flight_id,
f.departure_airport,
f.arrival_airport,
f.aircraft_code,
t.passenger_name,
tf.fare_conditions AS fc_to_be,
s.fare_conditions AS fc_fact,
b.seat_no
FROM boarding_passes b
JOIN ticket_flights tf
ON b.ticket_no = tf.ticket_no AND b.flight_id = tf.flight_id
JOIN ticketss t ON tf.ticket_no = t.ticket_no
JOIN flights f ON tf.flight_id = f.flight_id
JOIN seats s
ON b.seat_no = s.seat_no AND f.aircraft_code = s.aircraft_code
WHERE tf.fare_conditions <> s.fare_conditions
ORDER BY f.flight_no, f.scheduled_departure;

select * from ticket_flights

SELECT r.min_sum, r.max_sum, count( b.* )
FROM bookings b
RIGHT OUTER JOIN
( VALUES ( 0, 100000 ), ( 100000, 200000 ),
( 200000, 300000 ), ( 300000, 400000 ),
( 400000, 500000 ), ( 500000, 600000 ),
( 600000, 700000 ), ( 700000, 800000 ),
( 800000, 900000 ), ( 900000, 1000000 ),
( 1000000, 1100000 ), ( 1100000, 1200000 ),
( 1200000, 1300000 )
) AS r ( min_sum, max_sum )
ON b.total_amount >= r.min_sum AND b.total_amount < r.max_sum
GROUP BY r.min_sum, r.max_sum
ORDER BY r.min_sum;

SELECT arrival_city FROM routes
WHERE departure_city = 'Москва'
ORDER BY arrival_city;
UNION
SELECT arrival_city FROM routes
WHERE departure_city = 'Санкт-Петербург'
ORDER BY arrival_city;

SELECT arrival_city FROM routes
WHERE departure_city = 'Москва'
INTERSECT
SELECT arrival_city FROM routes
WHERE departure_city = 'Санкт-Петербург'
ORDER BY arrival_city;

SELECT arrival_city FROM routes
WHERE departure_city = 'Санкт-Петербург'
EXCEPT
SELECT arrival_city FROM routes
WHERE departure_city = 'Москва'
ORDER BY arrival_city;

SELECT avg( total_amount ) FROM bookings;

SELECT max( total_amount ) FROM bookings;

SELECT min( total_amount ) FROM bookings;

SELECT arrival_city, count( * )
FROM routes
WHERE departure_city = 'Москва'
GROUP BY arrival_city
ORDER BY count DESC;

SELECT array_length( days_of_week, 1 ) AS days_per_week,
count( * ) AS num_routes
FROM routes
GROUP BY days_per_week
ORDER BY 1 desc;

SELECT departure_city, count( * )
FROM routes
GROUP BY departure_city
HAVING count( * ) >= 15
ORDER BY count DESC;

SELECT city, count( * )
FROM airports
GROUP BY city
HAVING count( * ) > 1;

SELECT b.book_ref,
b.book_date,
extract( 'month' from b.book_date ) AS month,
extract( 'day' from b.book_date ) AS day,
count( * ) OVER (
PARTITION BY date_trunc( 'month', b.book_date )
ORDER BY b.book_date
) AS count
FROM ticket_flights tf
JOIN ticketss t ON tf.ticket_no = t.ticket_no
JOIN bookings b ON t.book_ref = b.book_ref
WHERE tf.flight_id = 1
ORDER BY b.book_date;

SELECT airport_name,
city,
round( latitude::numeric, 2 ) AS ltd,
timezone,
rank() OVER (
PARTITION BY timezone
ORDER BY latitude DESC
)
FROM airports
WHERE timezone IN ( 'Asia/Irkutsk', 'Asia/Krasnoyarsk' )
ORDER BY timezone, rank;

SELECT airport_name, city, timezone, latitude,
first_value( latitude ) OVER tz AS first_in_timezone,
latitude - first_value( latitude ) OVER tz AS delta,
rank() OVER tz
FROM airports
WHERE timezone IN ( 'Asia/Irkutsk', 'Asia/Krasnoyarsk' )
WINDOW tz AS ( PARTITION BY timezone ORDER BY latitude DESC )
ORDER BY timezone, rank;

SELECT count( * ) FROM bookings
WHERE total_amount >
( SELECT avg( total_amount ) FROM bookings );

SELECT flight_no, departure_city, arrival_city
FROM routes
WHERE departure_city IN (
SELECT city
FROM airports
WHERE timezone ~ 'Krasnoyarsk'
)
AND arrival_city IN (
SELECT city
FROM airports
WHERE timezone ~ 'Krasnoyarsk'
);

SELECT airport_name, city, longitude
FROM airports
WHERE longitude IN (
( SELECT max( longitude ) FROM airports ),
( SELECT min( longitude ) FROM airports )
)
ORDER BY longitude;

select * from airports

SELECT DISTINCT a.city
FROM airports a
WHERE NOT EXISTS (
SELECT * FROM routes r
WHERE r.departure_city = 'Москва'
AND r.arrival_city = a.city
)
AND a.city <> 'Москва'
ORDER BY city;

SELECT a.model,
( SELECT count( * )
FROM seats s
WHERE s.aircraft_code = a.aircraft_code
AND s.fare_conditions = 'Business'
) AS business,
( SELECT count( * )
FROM seats s
WHERE s.aircraft_code = a.aircraft_code
AND s.fare_conditions = 'Comfort'
) AS comfort,
( SELECT count( * )
FROM seats s
WHERE s.aircraft_code = a.aircraft_code
AND s.fare_conditions = 'Economy'
) AS economy
FROM aircrafts a
ORDER BY 1;

SELECT s2.model,
string_agg(
s2.fare_conditions || ' (' || s2.num || ')',
', '
)
FROM (
SELECT a.model,
s.fare_conditions,
count( * ) AS num
FROM aircrafts a
JOIN seats s ON a.aircraft_code = s.aircraft_code
GROUP BY 1, 2
ORDER BY 1, 2
) AS s2
GROUP BY s2.model
ORDER BY s2.model;

SELECT aa.city, aa.airport_code, aa.airport_name
FROM (
SELECT city, count( * )
FROM airports
GROUP BY city
HAVING count( * ) > 1
) AS a
JOIN airports AS aa ON a.city = aa.city
ORDER BY aa.city, aa.airport_name;

SELECT departure_airport, departure_city, count( * )
FROM routes
GROUP BY departure_airport, departure_city
HAVING departure_airport IN (
SELECT airport_code
FROM airports
WHERE longitude > 150
)
ORDER BY count DESC;

SELECT ts.flight_id,
ts.flight_no,
ts.scheduled_departure_local,
ts.departure_city,
ts.arrival_city,
a.model,
ts.fact_passengers,
ts.total_seats,
round( ts.fact_passengers::numeric /
ts.total_seats::numeric, 2 ) AS fraction
FROM (
SELECT f.flight_id,
f.flight_no,
f.scheduled_departure_local,
f.departure_city,
f.arrival_city,
f.aircraft_code,
count( tf.ticket_no ) AS fact_passengers,
( SELECT count( s.seat_no )
FROM seats s
WHERE s.aircraft_code = f.aircraft_code
) AS total_seats
FROM flights_v f
JOIN ticket_flights tf ON f.flight_id = tf.flight_id
WHERE f.status = 'Arrived'
GROUP BY 1, 2, 3, 4, 5, 6
) AS ts
JOIN aircrafts AS a ON ts.aircraft_code = a.aircraft_code
ORDER BY ts.scheduled_departure_local;

WITH RECURSIVE ranges ( min_sum, max_sum ) AS
( VALUES ( 0, 100000 )
UNION ALL
SELECT min_sum + 100000, max_sum + 100000
FROM ranges
WHERE max_sum <
( SELECT max( total_amount ) FROM bookings )
)
SELECT * FROM ranges;

WITH RECURSIVE ranges ( min_sum, max_sum ) AS
( VALUES( 0, 100000 )
UNION ALL
SELECT min_sum + 100000, max_sum + 100000
FROM ranges
WHERE max_sum <
( SELECT max( total_amount ) FROM bookings )
)
SELECT r.min_sum, r.max_sum, count( b.* )
FROM bookings b
RIGHT OUTER JOIN ranges r
ON b.total_amount >= r.min_sum
AND b.total_amount < r.max_sum
GROUP BY r.min_sum, r.max_sum
ORDER BY r.min_sum;

----- individual tasks -----

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

SELECT departure_city, arrival_city
FROM routes r
JOIN aircrafts a ON r.aircraft_code = a.aircraft_code
WHERE a.model = 'Боинг 737-300'
GROUP BY departure_city, arrival_city
HAVING departure_city != arrival_city
ORDER BY 1; -- 7 ????


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

----- tasks sql-ex.ru -----

select model, speed, hd
from PC
where price < 500 -- 1(1) ok

select distinct maker
from Product
where type = 'Printer' -- 2(1) ok

select model, ram, screen
from Laptop
where price > 1000 -- 3(1) ok

select *
from Printer
where color = 'y' -- 4(1) ok

select model, speed, hd
from PC
where (cd = '12x' or cd = '24x') and price < 600 -- 5(1) ok