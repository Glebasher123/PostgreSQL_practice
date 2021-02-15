CREATE TABLE pilots
( 
	pilot_name text,
	schedule integer[],
	meal text[][]
);

INSERT INTO pilots VALUES ( 'Ivan','{ 1, 3, 5, 6, 7 }'::integer[],'{{ "сосиска", "макароны", "кофе" },{ "котлета", "каша", "кофе"}}'::text[][])
INSERT INTO pilots VALUES ( 'Petr', '{ 1, 2, 5, 7 }'::integer[],'{{ "котлета", "каша", "кофе" },{ "сосиска", "каша", "кофе" },{ "котлета", "каша", "чай" }}'::text[][])

select * from pilots

UPDATE pilot_hobbies
SET hobbies = jsonb_set( hobbies, '{ home_lib }', 'false' )
WHERE pilot_name = 'Boris';

SELECT pilot_name, hobbies->'trips' AS trips FROM pilot_hobbies;

SELECT '{ "sports": "хоккей" }'::jsonb || '{ "trips": 5 }'::jsonb;

select * from pilot_hobbies

UPDATE pilot_hobbies
SET hobbies = hobbies || '{ "age": 15 }'
WHERE pilot_name = 'Boris'; --36

UPDATE pilot_hobbies
SET hobbies = hobbies - 'age' --37

SELECT * FROM aircrafts_data

DROP TABLE aircrafts;

DROP  aircrafts CASCADE;

ALTER TABLE airports
ADD COLUMN speed integer NOT NULL CHECK( speed >= 300 );

CREATE TABLE airports
(
airport_code char( 3 ) NOT NULL, -- Код аэропорта
airport_name text NOT NULL, -- Название аэропорта
city text NOT NULL, -- Город
longitude float NOT NULL, -- Координаты аэропорта: долгота
latitude float NOT NULL, -- Координаты аэропорта: ширина
timezone text NOT NULL, -- Часовой пояс аэропорта
PRIMARY KEY ( airport_code )
);

ALTER TABLE aircrafts_data ADD COLUMN speed integer;

UPDATE aircrafts_data SET speed = 807 WHERE aircraft_code = '733';
UPDATE aircrafts_data SET speed = 851 WHERE aircraft_code = '763';
UPDATE aircrafts_data SET speed = 905 WHERE aircraft_code = '773';
UPDATE aircrafts_data SET speed = 840 WHERE aircraft_code IN ( '319', '320', '321' );
UPDATE aircrafts_data SET speed = 786 WHERE aircraft_code = 'CR2';
UPDATE aircrafts_data SET speed = 341 WHERE aircraft_code = 'CN1';
UPDATE aircrafts_data SET speed = 830 WHERE aircraft_code = 'SU9';

SELECT * FROM aircrafts_data;
ALTER TABLE aircrafts_data ALTER COLUMN speed SET NOT NULL;
ALTER TABLE aircrafts_data ADD CHECK( speed >= 300 );

ALTER TABLE airports_data
ALTER COLUMN longitude SET DATA TYPE numeric( 5,2 ),
ALTER COLUMN latitude SET DATA TYPE numeric( 5,2 );

CREATE TABLE fare_conditions
( fare_conditions_code integer,
fare_conditions_name varchar( 10 ) NOT NULL,
PRIMARY KEY ( fare_conditions_code )
);

INSERT INTO fare_conditions VALUES ( 1, 'Economy' ), ( 2, 'Business' ),( 3, 'Comfort' );

ALTER TABLE seats
DROP CONSTRAINT seats_fare_conditions_check,
ALTER COLUMN fare_conditions SET DATA TYPE integer
USING ( CASE WHEN fare_conditions = 'Economy' THEN 1
WHEN fare_conditions = 'Business' THEN 2
ELSE 3 END
);

ALTER TABLE seats ADD FOREIGN KEY ( fare_conditions ) REFERENCES fare_conditions ( fare_conditions_code );

ALTER TABLE seats
RENAME COLUMN fare_conditions TO fare_conditions_code;

ALTER TABLE seats RENAME CONSTRAINT seats_fare_conditions_fkey TO seats_fare_conditions_code_fkey;

ALTER TABLE fare_conditions ADD UNIQUE ( fare_conditions_name );

SELECT aircraft_code, fare_conditions_code, count( * )
FROM seats
GROUP BY aircraft_code, fare_conditions_code
ORDER BY aircraft_code, fare_conditions_code;

SELECT * FROM bookings.aircrafts;

SHOW search_path;