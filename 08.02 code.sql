INSERT INTO aircrafts (aircraft_code, model, range) VALUES ( '123', 'Sukhoi SuperJet-200', 3000 );
 
select * from aircrafts
--WHERE range >= 4000 AND range <= 6000
ORDER BY range DESC 
 
UPDATE aircrafts SET range = 4500
WHERE aircraft_code = 'SU9';
 
DELETE FROM aircrafts WHERE aircraft_code = 'CN1'
DELETE FROM aircrafts WHERE range > 10000 OR range < 3000
 
update aircrafts set range = range * 2
where model = 'Сухой Суперджет-100'
 
DELETE FROM aircrafts WHERE aircraft_code = 'CN2'