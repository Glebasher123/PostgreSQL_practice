select current_date
select to_char(current_date, 'dd-mm-yyyy')

SELECT '21:15:25'::time;

select current_time

select timestamp '2016-11-12 14:15:12'

select current_timestamp

select (date_trunc('hour', current_timestamp))

CREATE TABLE databases ( is_open_source boolean, dbms_name text );

INSERT INTO databases VALUES ( TRUE, 'PostgreSQL' );
INSERT INTO databases VALUES ( FALSE, 'Oracle' );
INSERT INTO databases VALUES ( TRUE, 'MySQL' );
INSERT INTO databases VALUES ( FALSE, 'MS SQL Server' );

select * from databases

select * from databases
where is_open_source --выберем из таблицы только true

CREATE TABLE pilots
(
pilot_name text,
schedule integer[]
);

INSERT INTO pilots
VALUES ( 'Ivan', '{ 1, 3, 5, 6, 7 }'::integer[] ),
( 'Petr', '{ 1, 2, 5, 7 }'::integer[] ),
( 'Pavel', '{ 2, 5 }'::integer[] ),
( 'Boris', '{ 3, 5, 6 }'::integer[] );

select * from pilots

UPDATE pilots
SET schedule = schedule || 7
WHERE pilot_name = 'Boris'; --добавим Борису 7 день

UPDATE pilots
SET schedule = array_append( schedule, 6 )
WHERE pilot_name = 'Pavel'; --добавим 6 день в конец массива

UPDATE pilots
SET schedule = array_prepend( 1, schedule )
WHERE pilot_name = 'Pavel'; --добавим 1 в начало списка

UPDATE pilots
SET schedule = array_remove( schedule, 5 )
WHERE pilot_name = 'Ivan'; --удалим 5 день

UPDATE pilots
SET schedule[ 1 ] = 2, schedule[ 2 ] = 3
WHERE pilot_name = 'Petr'; --изменим 1 день на 2; 2 день на 3

SELECT * FROM pilots
WHERE array_position( schedule, 3 ) IS NOT NULL; --выберем которые летают только по средам

SELECT * FROM pilots
WHERE schedule @> '{ 1, 7 }'::integer[]; --летающие только по 1 и 7

SELECT * FROM pilots
WHERE schedule && ARRAY[ 2, 5 ]; -- 2 ИЛИ 5

SELECT * FROM pilots
WHERE NOT schedule && ARRAY[ 2, 5 ]; --не 2 или 5

SELECT unnest( schedule ) AS days_of_week -- массив в виде столбца
FROM pilots
WHERE pilot_name = 'Ivan';

CREATE TABLE pilot_hobbies
(
pilot_name text,
hobbies jsonb
);

INSERT INTO pilot_hobbies
VALUES ( 'Ivan',
'{ "sports": [ "футбол", "плавание" ],
"home_lib": true, "trips": 3
}'::jsonb
),
( 'Petr',
'{ "sports": [ "теннис", "плавание" ],
"home_lib": true, "trips": 2
}'::jsonb
),
( 'Pavel',
'{ "sports": [ "плавание" ],
"home_lib": false, "trips": 4
}'::jsonb
),
( 'Boris',
'{ "sports": [ "футбол", "плавание", "теннис" ],
"home_lib": true, "trips": 0
}'::jsonb
);

SELECT * FROM pilot_hobbies
WHERE hobbies @> '{ "sports": ["плавание"] }'::jsonb;

select * from pilot_hobbies

SELECT count( * )
FROM pilot_hobbies
WHERE hobbies ? 'sports';

UPDATE pilot_hobbies
SET hobbies = hobbies || '{ "sports": [ "хоккей" ] }'
WHERE pilot_name = 'Boris';

UPDATE pilot_hobbies
SET hobbies = jsonb_set( hobbies, '{ sports, 1 }', '"футбол"' )
WHERE pilot_name = 'Boris';

CREATE TABLE test_numeric
( 
	measurement numeric(5, 2),
	description text
);

INSERT INTO test_numeric
VALUES ( 999.9999, 'Какое-то измерение ' ); --c ошибкой (т.к когда число округлится до 1000, после него будет стоять .00 и будет 6 символов, вместо допущенных 5)
INSERT INTO test_numeric
VALUES ( 999.9009, 'Еще одно измерение' );
INSERT INTO test_numeric
VALUES ( 999.1111, 'И еще измерение' );
INSERT INTO test_numeric
VALUES ( 998.9999, 'И еще одно' );

select * from test_numeric

CREATE TABLE test_numeric2
( 
	measurement numeric,
	description text
);

INSERT INTO test_numeric2
VALUES ( 1234567890.0987654321,
'Точность 20 знаков, масштаб 10 знаков' );
INSERT INTO test_numeric2
VALUES ( 1.5,
'Точность 2 знака, масштаб 1 знак' );
INSERT INTO test_numeric2
VALUES ( 0.12345678901234567890,
'Точность 21 знак, масштаб 20 знаков' );
INSERT INTO test_numeric2
VALUES ( 1234567890,
'Точность 10 знаков, масштаб 0 знаков (целое число)' );

select * from test_numeric2

SELECT 'NaN'::numeric > 10000;

SELECT '5e-324'::double precision > '4e-324'::double precision;

SELECT '5e-324'::double precision;

SELECT '4e-324'::double precision;


SELECT '1E-37'::real > '1E+37'::real;

SELECT 'Inf'::double precision > 1E-307;

SELECT 0 * 'Inf'::real;

select 'NaN'::real > 'Inf'::real;

CREATE TABLE test_serial
( 
	id serial,
	name text
);

INSERT INTO test_serial ( name ) VALUES ( 'Вишневая' );
INSERT INTO test_serial ( name ) VALUES ( 'Грушевая' );
INSERT INTO test_serial ( name ) VALUES ( 'Зеленая' );

select * from test_serial

INSERT INTO test_serial ( id, name ) VALUES ( 5, 'Прохладная' );

INSERT INTO test_serial ( name ) VALUES ( 'Луговая' );

CREATE TABLE test_serial2
( 
	id serial PRIMARY KEY,
	name text
);

select * from test_serial2

INSERT INTO test_serial2 ( name ) VALUES ( 'Вишневая' );

INSERT INTO test_serial2 ( id, name ) VALUES ( 2, 'Прохладная' );

INSERT INTO test_serial2 ( name ) VALUES ( 'Грушевая' );

INSERT INTO test_serial2 ( name ) VALUES ( 'Зеленая' );

INSERT INTO test_serial2 ( name ) VALUES ( 'Луговая' );

DELETE FROM test_serial2 WHERE id = 4;



