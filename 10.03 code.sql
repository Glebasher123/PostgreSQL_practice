ALTER TABLE flights ADD CHECK ( actual_arrival IS NULL OR ( actual_departure IS NOT NULL AND actual_arrival > actual_departure));

select * from birthdays

UPDATE flights
SET actual_departure = '2017-06-22 19:10:25-07', actual_arrival = '2019-06-22 19:10:25-07'
WHERE flight_id = 3940 --11

ALTER TABLE tickets RENAME TO ticketss; --12

DROP TABLE airports_data; --13

CREATE VIEW test_view AS SELECT * from birthdays

INSERT INTO test_view SELECT 'Petrov petr', '2000-12-12';

UPDATE test_view SET person = 'Petrov petra', birthday = '2001-05-22';
WHERE birthday = '2000-12-12' --14

-- +15
-- 16 ???

CREATE VIEW airports_names AS
SELECT airport_code, airport_name, city
FROM airports;

SELECT * FROM airports_names;

CREATE VIEW siberian_airports AS
SELECT * FROM airports
WHERE city = 'Новосибирск' OR city = 'Кемерово';

SELECT * FROM siberian_airports;

select * from pilots

CREATE VIEW passengers AS
SELECT passenger_name, contact_data FROM ticketss

SELECT * FROM passengers;

CREATE VIEW pilots_view AS
SELECT * FROM pilots
WHERE pilot_name = 'Ivan' OR pilot_name = 'Petr';

SELECT * FROM pilots_view; --17

ALTER TABLE aircrafts_data ADD COLUMN specifications jsonb;

UPDATE aircrafts_data
SET specifications ='{ "crew": 2, "engines": { "type": "IAE V2500", "num": 2}}'::jsonb
WHERE aircraft_code = '320';

SELECT model, specifications
FROM aircrafts_data
WHERE aircraft_code = '320';

SELECT model, specifications->'engines' AS engines
FROM aircrafts_data
WHERE aircraft_code = '320';

select * from pilots

ALTER TABLE pilots ADD COLUMN additional_information jsonb;

UPDATE pilots
SET additional_information ='{"age": 17}'::jsonb --18

--6--

SELECT * FROM aircrafts;
SELECT * FROM airports;

SELECT * FROM aircrafts WHERE model LIKE 'Аэробус%';

SELECT * FROM aircrafts
WHERE model NOT LIKE 'Аэробус%'
AND model NOT LIKE 'Боинг%';

SELECT * FROM airports WHERE airport_name LIKE '___'; -- поиск по 3м символам
SELECT * FROM aircrafts WHERE model ~ '^(A|Boe)';
SELECT * FROM aircrafts WHERE model !~ '300$';
SELECT * FROM aircrafts WHERE range BETWEEN 3000 AND 6000;

SELECT model, range, range / 1.609 AS miles FROM aircrafts;
SELECT model, range, round( range / 1.609, 2 ) AS miles
FROM aircrafts;

SELECT * FROM aircrafts ORDER BY range DESC;

SELECT timezone FROM airports;
SELECT DISTINCT timezone FROM airports ORDER BY 1;

SELECT airport_name, city, longitude
FROM airports
ORDER BY longitude DESC
LIMIT 3;

SELECT airport_name, city, coordinates
FROM airports_data
ORDER BY coordinates DESC
LIMIT 3
OFFSET 3;

SELECT model, range,
CASE WHEN range < 2000 THEN 'Ближнемагистральный'
WHEN range < 5000 THEN 'Среднемагистральный'
ELSE 'Дальнемагистральный'
END AS type
FROM aircrafts
ORDER BY model;


