CREATE TEMP TABLE aircrafts_tmp AS
SELECT * FROM aircrafts WITH NO DATA;

ALTER TABLE aircrafts_tmp
ADD PRIMARY KEY ( aircraft_code );
ALTER TABLE aircrafts_tmp
ADD UNIQUE ( model );

CREATE TEMP TABLE aircrafts_log AS
SELECT * FROM aircrafts WITH NO DATA;

ALTER TABLE aircrafts_log
ADD COLUMN when_add timestamp;
ALTER TABLE aircrafts_log
ADD COLUMN operation text;

WITH add_row AS
( INSERT INTO aircrafts_tmp
SELECT * FROM aircrafts
RETURNING *
)
INSERT INTO aircrafts_log
SELECT add_row.aircraft_code, add_row.model, add_row.range,
current_timestamp, 'INSERT'
FROM add_row;

SELECT * FROM aircrafts_log ORDER BY model;

INSERT INTO aircrafts_tmp
VALUES ( 'SU9', 'Сухой Суперджет-100', 3000 )
ON CONFLICT ( aircraft_code ) DO NOTHING
RETURNING *;

INSERT INTO aircrafts_tmp
VALUES ( 'SU9', 'Сухой Суперджет-100', 3000 )
ON CONFLICT ON CONSTRAINT aircrafts_tmp_pkey
DO UPDATE SET model = excluded.model,
range = excluded.range
RETURNING *;

WITH update_row AS
( UPDATE aircrafts_tmp
SET range = range * 1.2
WHERE model ~ '^Bom'
RETURNING *
)
INSERT INTO aircrafts_log
SELECT ur.aircraft_code, ur.model, ur.range,
current_timestamp, 'UPDATE'
FROM update_row ur;

SELECT * FROM aircrafts_log
WHERE model ~ '^Бом' ORDER BY when_add;

CREATE TEMP TABLE tickets_directions AS
SELECT DISTINCT departure_city, arrival_city FROM routes;

ALTER TABLE tickets_directions
ADD COLUMN last_ticket_time timestamp;
ALTER TABLE tickets_directions
ADD COLUMN tickets_num integer DEFAULT 0;

CREATE TEMP TABLE ticket_flights_tmp AS
SELECT * FROM ticket_flights WITH NO DATA;
ALTER TABLE ticket_flights_tmp
ADD PRIMARY KEY ( ticket_no, flight_id );

WITH sell_ticket AS
( INSERT INTO ticket_flights_tmp
( ticket_no, flight_id, fare_conditions, amount )
VALUES ( '1234567890123', 30829, 'Economy', 12800 )
RETURNING *
)
UPDATE tickets_directions td
SET last_ticket_time = current_timestamp,
tickets_num = tickets_num + 1
WHERE ( td.departure_city, td.arrival_city ) =
( SELECT departure_city, arrival_city
FROM flights_v
WHERE flight_id = ( SELECT flight_id FROM sell_ticket )
);

SELECT *
FROM tickets_directions
WHERE tickets_num > 0;

WITH sell_ticket AS
( INSERT INTO ticket_flights_tmp
(ticket_no, flight_id, fare_conditions, amount )
VALUES ( '1234567890123', 7757, 'Economy', 3400 )
RETURNING *
)
UPDATE tickets_directions td
SET last_ticket_time = current_timestamp,
tickets_num = tickets_num + 1
FROM flights_v f
WHERE td.departure_city = f.departure_city
AND td.arrival_city = f.arrival_city
AND f.flight_id = ( SELECT flight_id FROM sell_ticket );

WITH delete_row AS
( DELETE FROM aircrafts_tmp
WHERE model ~ '^Bom'
RETURNING *
)
INSERT INTO aircrafts_log
SELECT dr.aircraft_code, dr.model, dr.range,
current_timestamp, 'DELETE'
FROM delete_row dr;

SELECT * FROM aircrafts_log
WHERE model ~ '^Бом' ORDER BY when_add;

WITH min_ranges AS
( SELECT aircraft_code,
rank() OVER (
PARTITION BY left( model, 6 )
ORDER BY range
) AS rank
FROM aircrafts_tmp
WHERE model ~ '^Airbus' OR model ~ '^Boeing'
)
DELETE FROM aircrafts_tmp a
USING min_ranges mr
WHERE a.aircraft_code = mr.aircraft_code
AND mr.rank = 1
RETURNING *;

----- individual task -----

INSERT INTO aircrafts_log
SELECT add_row.aircraft_code, add_row.model, add_row.range,
current_timestamp, 'INSERT'
FROM add_row; --1



WITH add_row AS
( INSERT INTO aircrafts_tmp
SELECT * FROM aircrafts
RETURNING aircraft_code, model, range,
current_timestamp, 'INSERT'
)
INSERT INTO aircrafts_log
SELECT * FROM add_row; --2

INSERT INTO aircrafts_tmp SELECT * FROM aircrafts;
INSERT INTO aircrafts_tmp SELECT * FROM aircrafts RETURNING *; --4

----- sql-ex.ru tasks -----

select distinct maker from Product
where type = 'PC' AND maker not in (select maker from Product WHERE type ='Laptop') -- 8(2) ok

select distinct maker from product
join pc on product.model = pc.model
where speed >= 450 -- 9(1) ok

select model, price from printer
where price = (select max(price) from printer) -- 10(1) ok

select avg(speed) as avgspeed from pc -- 11(1) ok

select avg(speed) as avgspeed from laptop
where price > 1000 --12(1) ok

select avg(speed) from product
join pc on product.model = pc.model
where maker = 'A' --13(1) ok

select classes.class, name, country from classes
join ships on classes.class = ships.class
where numGuns >= 10 -- 14(1) ok

select hd from pc
group by hd
having count(model) >= 2 -- 15(1) ok
