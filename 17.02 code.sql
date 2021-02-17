SELECT * FROM airports_data;

ALTER TABLE airports_data ALTER COLUMN coordinates SET DATA TYPE numeric( 5,2 );

CREATE VIEW seats_by_fare_cond AS
SELECT aircraft_code, fare_conditions_code, count( * )
FROM seats
GROUP BY aircraft_code, fare_conditions_code
ORDER BY aircraft_code, fare_conditions_code;

select * from seats

SELECT * FROM seats_by_fare_cond;

DROP VIEW seats_by_fare_cond;

CREATE OR REPLACE VIEW seats_by_fare_cond AS
SELECT aircraft_code, fare_conditions_code, count( * ) AS num_seats
FROM seats
GROUP BY aircraft_code, fare_conditions_code
ORDER BY aircraft_code, fare_conditions_code;

SHOW search_path;

SET search_path = bookings;

-------individual task-------
select * from students
ALTER TABLE students ADD who_adds_row text DEFAULT current_user;

INSERT INTO students ( record_book, name, doc_ser, doc_num )
VALUES ( 12300, 'Иванов Иван Иванович', 0402, 543281 );

ALTER TABLE students ADD time_addition timestamp DEFAULT current_timestamp;

INSERT INTO students ( record_book, name, doc_ser, doc_num )
VALUES ( 15900, 'Петров Петр Петрович', 0403, 745965 ); --1

SELECT * FROM progress

ALTER TABLE progress ADD test_form varchar(7);

ALTER TABLE progress
ADD CHECK (
( test_form = 'экзамен' AND mark IN ( 3, 4, 5 ) )
OR
( test_form = 'зачёт' AND mark IN ( 0, 1 ) )
);
ALTER TABLE progress ADD COLUMN mark numeric(1);
INSERT INTO progress (record_book, subject, acad_year, term, mark, test_form) VALUES (12300, 'информатика', 'первый', 1, 1, 'зачёт')

ALTER TABLE progress 
ADD CHECK (
(subject = 'математика' OR subject = 'физкультура' OR subject = 'физика' OR subject = 'информатика')
); --2

ALTER TABLE progress ALTER COLUMN DROP NOT NULL;

INSERT INTO progress (record_book, subject, acad_year,mark, test_form) VALUES (15900, 'информатика', 'первый', 1, 'зачёт')
-- не избыточно, т.к. значения null добавляются
--3
ALTER TABLE progress ALTER COLUMN term SET NOT NULL;
INSERT INTO progress ( record_book, subject, acad_year, term ) VALUES ( 12300, 'физика', '2016/2017',1 ); --4

ALTER TABLE students ADD UNIQUE (doc_ser);
ALTER TABLE students ADD UNIQUE (doc_num);

INSERT INTO students ( record_book, name) VALUES ( 12909, 'Иванов Иван Иванович'); --5

CREATE TABLE students
( record_book numeric( 5 ) NOT NULL UNIQUE,
name text NOT NULL,
doc_ser numeric( 4 ),
doc_num numeric( 6 ),
PRIMARY KEY ( doc_ser, doc_num )
);

CREATE TABLE progress
( doc_ser numeric( 4 ),
doc_num numeric( 6 ),
subject text NOT NULL,
acad_year text NOT NULL,
term numeric( 1 ) NOT NULL CHECK ( term = 1 OR term = 2 ),
mark numeric( 1 ) NOT NULL CHECK ( mark >= 3 AND mark <= 5 )
DEFAULT 5,
FOREIGN KEY ( doc_ser, doc_num )
REFERENCES students ( doc_ser, doc_num )
ON DELETE CASCADE
ON UPDATE CASCADE
);

SELECT * FROM students
SELECT * FROM progress

INSERT INTO students (record_book, name, doc_ser, doc_num) VALUES (1, 'Валентинов Иван Александрович', 0001,0001)
INSERT INTO progress (doc_ser, doc_num, subject, acad_year, term, mark) VALUES (1,1,'математика', '2019/2020', 2,3)

INSERT INTO students (record_book, name, doc_ser, doc_num) VALUES (2, 'Валентинов Иван Александрович', 2,2)
INSERT INTO students (record_book, name, doc_ser, doc_num) VALUES (3, 'Валентинов Иван Александрович', 3,3)
INSERT INTO students (record_book, name, doc_ser, doc_num) VALUES (5, 'Петров Иван Александрович', 5,5)

INSERT INTO progress (doc_ser, doc_num, subject, acad_year, term, mark) VALUES (5,5,'физика', '2019/2020', 2,3) --6


UPDATE students SET doc_ser = 4, doc_num = 4
WHERE record_book = 4

DELETE FROM students 
WHERE doc_ser = 1; --7

CREATE TABLE subjects
(
	subject_id integer PRIMARY KEY,
	subject text UNIQUE
)
 
INSERT INTO subjects (subject_id, subject) VALUES (1, 'Математика'),(2, 'Физика'), (3, 'Русский язык');
select * from students

ALTER TABLE progress
RENAME COLUMN subject TO subject_id

ALTER TABLE progress
ALTER COLUMN subject_id SET DATA TYPE integer
USING ( CASE WHEN subject_id = 'математика' THEN 1
WHEN subject_id = 'физика' THEN 2
ELSE 3
END );

ALTER TABLE progress
ADD FOREIGN KEY (subject_id)

ALTER TABLE progress
  ADD FOREIGN KEY (subject_id) REFERENCES subjects(subject_id); 
  
INSERT INTO progress (doc_ser, doc_num, subject_id, acad_year, term, mark) VALUES (2,2,3, '2020/2021', 2,4)
--8

ALTER TABLE students ADD CHECK ( name <> '' );

INSERT INTO students VALUES ( 12346, ' ', 0406, 112233 );
INSERT INTO students VALUES ( 12347, ' ', 0407, 112234 );

SELECT *, length( name ) FROM students;

ALTER TABLE students ADD CHECK (...); --???
--9

ALTER TABLE students
ALTER COLUMN doc_ser TYPE varchar(5); --операция не выполнена
--10

