\c hotel_management;

SELECT* FROM EMPLOYEE;

SELECT* FROM bill;

DELETE FROM bill WHERE total_amt=2400;

DROP ROLE customer;

SELECT * FROM information_schema. table_privileges LIMIT 5;



SELECT* FROM employee WHERE salary > 55000;

SELECT* FROM employee WHERE salary > 55000 and dno=1;

SELECT room_name, cost FROM room_type where cost>2000;

SELECT order_fname, order_lname FROM orders WHERE capacity>=2;

SELECT checkin, checkout FROM bookings where dur_of_stay<10;

SELECT checkin, total_amt FROM bookings where checkin>'2021-01-14';



SELECT gfname,glname FROM guests WHERE credit_info='visa'
ORDER BY gfname;

SELECT type_id,room_name FROM room_type WHERE pet_friendly=0
ORDER BY type_id;

SELECT COUNT (DISTINCT gid) FROM bookings
WHERE (checkin>='2021-05-20') OR
(checkout<='2021-10-15');

SELECT rooms.room_no, COUNT(rooms.type) AS COUNT from rooms
GROUP BY rooms.room_no;

SELECT bill_id,bill_fname,SUM(total_amt)
FROM bill
GROUP BY bill_id;




--name of employees having mgr_ssn as 1
SELECT efname, elname
FROM EMPLOYEE
WHERE (SELECT mgr_ssn
FROM DEPARTMENT
WHERE dnumber = dno) = 1;


