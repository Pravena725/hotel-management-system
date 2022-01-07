drop database hotel_management;
create database hotel_management;

\c hotel_management

create table employee(
 emp_id int PRIMARY KEY,
 EFname varchar(255) NOT NULL,
 ELname varchar(255) NOT NULL,
 Ephno varchar(15),
 Eaddr varchar(255),
 Eemail varchar(255),
 salary float,
 Super_ssn int,
 Dno int
 );

 create table employee_audits(
    emp_id int PRIMARY KEY,
    ELname varchar(255) NOT NULL,
    changed_on Timestamp(6) NOT NULL
 );
 
create table department(
 dname varchar(255),
 dnumber int PRIMARY KEY,
 mgr_ssn int
);

create table bookings(
 booking_id int PRIMARY KEY,
 booking_date date,
 dur_of_stay int,
 checkin date,
 checkout date,
 pay_type varchar(255),
 gid int UNIQUE NOT NULL,
 eid int UNIQUE NOT NULL,
 total_amt float NOT NULL
);

create table bookings_audit(
    booking_id int PRIMARY KEY,
    guest_Id int,
    booked_date varchar(100) NOT NULL
);

create table guests(
 guest_id int PRIMARY KEY NOT NULL,
 GFname varchar(255),
 GLname varchar(255),
 Gphno varchar(15),
 Gaddr varchar(255) NOT NULL,
 Gemail varchar(255),
 credit_info varchar(255),
 id_proof varchar(255) NOT NULL
);

create table guest_audit(
    guest_id int PRIMARY KEY,
    GFname varchar(255),
    GLname varchar(255),
    Gphno varchar(15),
    Gaddr varchar(255) NOT NULL,
    Gemail varchar(255),
    deletedDate Timestamp NOT NULL
);



create table rooms(
 room_id int PRIMARY KEY,
 room_no int,
 r_type varchar(255) NOT NULL,
 vacant int DEFAUlT 1 
);

create table room_type(
 room_name varchar(255) UNIQUE NOT NULL,
 type_id int PRIMARY KEY,
 cost float NOT NULL,
 description varchar(255),
 pet_friendly int
);

create table rooms_booked(
 booked_id int PRIMARY KEY,
 bookings_booking_id int,
 rooms_room_id int
);

create table orders(
 order_id int PRIMARY KEY,
 order_fname varchar(255),
 order_lname varchar(255),
 price float,
 capacity int
);

create table tables(
 table_id int PRIMARY KEY,
 capacity int
);

create table bill(
 bill_id int PRIMARY KEY,
 total_amt float,
 created_at date,
 bill_fname varchar(255),
 bill_lname varchar(255),
 city varchar(255) default 'Bangalore',
 state varchar(255) default 'Karnataka',
 country varchar(255) default 'India'
);

alter table employee add FOREIGN KEY (super_ssn) REFERENCES employee (emp_id);

alter table employee add FOREIGN KEY (dno) REFERENCES department (dnumber);

alter table bookings add FOREIGN KEY (gid) REFERENCES guests (guest_id);

alter table bookings add FOREIGN KEY (eid) REFERENCES employee (emp_id);

alter table rooms_booked add FOREIGN KEY (bookings_booking_id) REFERENCES bookings (booking_id);

alter table rooms_booked add FOREIGN KEY (rooms_room_id) REFERENCES rooms (room_id);

alter table rooms add FOREIGN KEY (r_type) REFERENCES room_type (room_name);

-- PROCEDURES
create or replace procedure show_available_rooms()
	language plpgsql
	as
	$$
	declare
		-- cur cursor for select * from rooms as R, rooms_booked as B where R.room_id - B.rooms_room_id;
		-- rec record;
	begin

		-- select * from rooms as R, rooms_booked as B where R.room_id - B.rooms_room_id;
		-- select * from rooms EXCEPT select * from rooms_booked;
		select DISTINCT rooms.* from (rooms as R LEFT OUTER JOIN rooms_booked as B on R.room_id=B.rooms_room_id) where B.rooms_room_id is NULL;
	
		-- select room_no, r_type, cost from ROOMS as R, ROOM_TYPE as T  where rooms.empty='true';

	end;
	$$;
	


-- write new booking records
create or replace procedure update_bookings(book_id int, book_date date, stay_dur int, checkin date, checkout date, payType varchar(255), guestID int, empID int, amt float)
	language plpgsql
	as
	$$
	declare
		
	begin
		INSERT into BOOKINGS values(book_id, book_date, stay_dur, checkin, checkout, payType, guestID, empID, amt);
		raise notice 'Updated bookings data';
	end;
	$$;
	

	
-- to insert new departments
create or replace procedure add_new_department(dep_name varchar(25), dep_no int, mSSN int)
	language plpgsql
	as
	$$
	declare 
		check_dep_no integer;
	begin
		select count(*) into check_dep_no from department where dnumber=dep_no;
		-- if no duplicate department exists
		if(check_dep_no = 0) then

				if((dep_name is not NULL) and (dep_no is not NULL)) then
					insert into department values(dep_name, dep_no, mSSN);
				else 
					raise notice 'Department values cannot be NULL';
				end if;
		else
			raise notice 'Department already exists!';
		end if;
		
	end;
	$$;
	
	
-- FUNCTIONS

create or replace function book_room(rno int, book_id int, book_date date, stay_dur int, checkin date, checkout date, payType varchar(255), guestID int, empID int)
	returns int
	language plpgsql
	as 
	$$
	declare
		cur cursor for select * from rooms where vacant=1 and room_no=rno;
		rec record;
	
		flag integer;
		booking_cost float;
	begin
		open cur;
		fetch first from cur into rec;
		
		flag:=0;
		booking_cost := 0.00;
		
		if(rec is NULL) then
			raise notice 'Room-% already occupied',rno;
		else
			update rooms set vacant=0 where rooms.room_no=rec.room_no;
			-- update rooms_booked SET booked_id=book_id, rooms_room_id=rec.room_id, bookings_booking_id=rno;

			select cost into booking_cost from room_type as T, rooms as R where R.r_type=T.room_name;
			CALL update_bookings(book_id, book_date, stay_dur, checkin, checkout, payType, guestID, empID, booking_cost);
			insert into rooms_booked values(rno, book_id, rec.room_id);

			flag:=1;
		end if;
		
		raise notice 'Booked Status: %',flag;
		raise notice 'Booking Charge: %',booking_cost;


		close cur;
		return flag;
		
	end;
	$$;



create or replace function vacant_room(rno int)
	returns int
	language plpgsql
	as 
	$$
	declare
		cur cursor for select * from rooms where room_no=rno;
		rec record;
	
		flag integer;
		room_booking_id integer;
	begin
		open cur;
		fetch first from cur into rec; --first record

		flag:=0;

		if(rec is NULL) then
			raise notice 'Room-% does not exists!',rno;
		else
			if(rec.vacant = 1) then
				raise notice 'Room-% is already vacated.',rno;
			else
				update rooms set vacant=1 where rooms.room_no=rec.room_no;

				select bookings_booking_id into room_booking_id from rooms_booked as B where B.book_id=rno;

				delete from rooms_booked as R where R.rooms_room_id=rec.room_id;
				delete from bookings as B where B.booking_id=bookings_booking_id;
				flag:=1;
			end if;
		end if;
		
		raise notice 'Successfully vacated Room-% ',rno;

		close cur;
		return flag;
		
	end;
	$$;
	



-- Trigger functions

create or replace function log_changes_lastname()
	returns trigger
	language plpgsql
	as
	$$
		begin 
			if NEW.ELname <> OLD.ELname then
				insert into employee_audits values(OLD.emp_id, OLD.ELname, now() );
			end if;

			return NEW;
		end;
	$$;


create or replace function log_guest_delete()
	returns trigger
	language plpgsql
	as
	$$
		begin 
			insert into guest_audit values (new.guest_id, new.GFname, new.GLname, new.Gphno, new.Gaddr, new.Gemail, now());

			return NEW;
		end;
	$$;


create or replace function log_bookings()
	returns trigger
	language plpgsql
	as
	$$
		begin 
			insert into bookings_audit values (new.booking_id, new.gid, current_timestamp);

			return NEW;
		end;
	$$;


create or replace function notify_changes()
    returns trigger
	language plpgsql
	as
	$$
	declare
		cur cursor for select * from employee_audits where emp_id=NEW.emp_id;
		rec record;
	begin

		open cur;
		fetch first from cur into rec;

		raise notice 'Updated name to %',rec.ELname;
		raise notice ' on %',rec.changed_on; 
		close cur;

        return NEW;
		

	end;
	$$;

-- TRIGGERS
create trigger changes_lastname
    before update on employee
    for each row
    execute procedure log_changes_lastname();



create trigger inform_changes
    after update on employee
    for each row 
    execute procedure notify_changes();



create trigger afterDelete_guest 
    after delete on guests 
    for each row
    execute procedure log_guest_delete();



create trigger newBooking_trigger 
    after insert on bookings 
    for each row 
    execute procedure log_bookings();



\c hotel_management

INSERT into DEPARTMENT values('Housekeeping', 1, 1);
INSERT into DEPARTMENT values('Cooking', 2, 4);
INSERT into DEPARTMENT values('Accounts', 3, 8);
INSERT into DEPARTMENT values('Reception', 4, 12);
INSERT into DEPARTMENT values('Security', 5, 16);
INSERT into DEPARTMENT values('Electrical Maintenance', 6, 20);
INSERT into DEPARTMENT values('First Aid', 7, 24);
INSERT into DEPARTMENT values('Emergency', 8, 28);



INSERT into EMPLOYEE values (1, 'James', 'Borg', '888665555', '450 Stone, Houston,TX', 'james.borg@gmail.com', 55000, NULL, 1);
INSERT into EMPLOYEE values (2, 'John', 'Smith', '998665545', '731 Fondren,Houston,TX', 'john.smith@gmail.com', 35000, 1, 3);
INSERT into EMPLOYEE values (8, 'Ahmed', 'Jabber', '7786652533', '980 Dallas, Houston,TX', 'ahmed.jabber@gmail.com', 35000, NULL, 3);
INSERT into EMPLOYEE values (3, 'Franklin', 'Wong', '778665533', '638 voss,Houston,TX', 'franklin.wong@gmail.com', 30000, 8, 3);
INSERT into EMPLOYEE values (4, 'Alicia', 'Zelaya', '988455255', '3321 Castle,Spring,TX', 'alica.zelaya@yaahoo.com', 65000, NULL, 2);
INSERT into EMPLOYEE values (5, 'Jennifer', 'Wallace', '9867585821', '291 Berry, Bellaire,TX', 'jennifer@gmail.com', 45000, 2, 2);
INSERT into EMPLOYEE values (6, 'Ramesh', 'Narayan', '8884455920', '975 Fire Oak, Humble, TX', 'ramesh.narayan@gmail.com', 60000, 1, 1);
INSERT into EMPLOYEE values (7, 'Jonny', 'English', '998665533', '5631 Rice,Houston,TX', 'johnny.english@gmail.com', 60000, 1, 1);



INSERT into ROOM_TYPE values('Single', 21, 1200.00,'A room assigned to one person.', 0);
INSERT into ROOM_TYPE values('Double', 22, 2000.50,'A room assigned to two people', 0);
INSERT into ROOM_TYPE values('Triple', 23, 3500.25,'A room that can accommodate three persons', 1);
INSERT into ROOM_TYPE values('Queen', 24, 5000.00,'A room with a queen-sized bed. May be occupied by one or more people.', 1);
INSERT into ROOM_TYPE values('Single+Balcony', 25, 1500.00,'A room assigned to one person with a balcony', 0);
INSERT into ROOM_TYPE values('Single+lakeview', 26, 1800.00,'A room assigned to one person with a beautiful view of the lake', 1);
INSERT into ROOM_TYPE values('Double+Balcony', 27, 2300.00,'A room assigned to two people with a balcony', 0);
INSERT into ROOM_TYPE values('Double+lakeview', 28, 2800.00,'A room assigned to two people with a beautiful view of the lake', 1);

INSERT into ROOMS values(1, 101, 'Single');
INSERT into ROOMS values(2, 102, 'Double');
INSERT into ROOMS values(3, 103, 'Double+Balcony');
INSERT into ROOMS values(4, 104, 'Single+Balcony');
INSERT into ROOMS values(5, 201, 'Single+lakeview');
INSERT into ROOMS values(6, 202, 'Double');
INSERT into ROOMS values(7, 203, 'Triple');
INSERT into ROOMS values(8, 301, 'Double+Balcony');
INSERT into ROOMS values(9, 302, 'Queen');
INSERT into ROOMS values(10, 303, 'Triple');
INSERT into ROOMS values(11, 304, 'Single+lakeview');
INSERT into ROOMS values(12, 305, 'Double+lakeview');


INSERT into TABLES values(101, 2);
INSERT into TABLES values(102, 2);
INSERT into TABLES values(103, 2);
INSERT into TABLES values(104, 4);
INSERT into TABLES values(105, 4);
INSERT into TABLES values(106, 6);
INSERT into TABLES values(107, 6);
INSERT into TABLES values(108, 8);


INSERT into GUESTS values(1,'Salman','Khan','9900012345','112,mumbai','sallubhai@gmail.com','visa','voter id card');
INSERT into GUESTS values(2,'Mithali','Raj','9900054321','201,bangalore','mithaliraj@gmail.com','rupay','pan card');
INSERT into GUESTS values(3,'Smrithi','Mandhana','9945724378','420,pune','mandhana@gmail.com','maestro','aadhar card');
INSERT into GUESTS values(4,'MS','Dhoni','8892736433','007,jharkhand','Helicopter_six@gmail.com','maestro','aadhar card');
INSERT into GUESTS values(5,'Gautham','Gambhir','9743296116','70,Delhi','gauthi07@gmail.com','rupay','pan card');
INSERT into GUESTS values(6,'Rohit','Sharma','9900011111','264,Hyderabad','doublecentury@gmail.com','visa','voter id card');
INSERT into GUESTS values(7,'Virat','Kholi','9000000143','100,Delhi north','viratkohli@yahoo.com','visa','aadhar card');
INSERT into GUESTS values(8,'Sachin','Tendulkar','9988776655','10,Kerala','godofcricket@gmail.com','rupay','aadhar card');


--remove manual reservations

-- INSERT into BOOKINGS values(100,'2021-01-10',3,'2021-01-14','2021-01-17','Card',1,1,10000.00);
-- INSERT into BOOKINGS values(101,'2021-01-25',8,'2021-02-02','2021-02-10','Cash',2,2,15000.00);
-- INSERT into BOOKINGS values(102,'2021-03-10',2,'2021-03-22','2021-03-24','paytm',3,3,9000.00);
-- INSERT into BOOKINGS values(103,'2021-04-12',11,'2021-04-18','2021-04-29','Card',4,4,22500.00);
-- INSERT into BOOKINGS values(104,'2021-05-18',5,'2021-05-20','2021-05-25','Cash',5,5,17500.00);
-- INSERT into BOOKINGS values(105,'2021-06-12',3,'2021-06-11','2021-06-14','Cash',6,6,12700.00);
-- INSERT into BOOKINGS values(106,'2021-06-30',9,'2021-07-05','2021-07-14','paytm',7,7,9900.00);
-- INSERT into BOOKINGS values(107,'2021-07-27',1,'2021-08-19','2021-08-20','Card',8,8,2400.00);


-- INSERT into ROOMS_BOOKED values(1, 100, 1);
-- INSERT into ROOMS_BOOKED values(2, 101, 2);
-- INSERT into ROOMS_BOOKED values(3, 102, 3);
-- INSERT into ROOMS_BOOKED values(4, 103, 4);
-- INSERT into ROOMS_BOOKED values(5, 104, 5);
-- INSERT into ROOMS_BOOKED values(6, 105, 6);
-- INSERT into ROOMS_BOOKED values(7, 106, 7);
-- INSERT into ROOMS_BOOKED values(8, 107, 8);

--new booking statements
SELECT book_room(100, 1, '2021-01-10',3,'2021-01-14','2021-01-17','Card', 1, 1);
SELECT book_room(101, 2,'2021-01-25',8,'2021-02-02','2021-02-10','Cash',2,2);
SELECT book_room(102, 3, '2021-03-10',2,'2021-03-22','2021-03-24','paytm',3,3);
SELECT book_room(103, 4, '2021-04-12',11,'2021-04-18','2021-04-29','Card',4,4);
SELECT book_room(201, 5, '2021-05-18',5,'2021-05-20','2021-05-25','Cash',5,5);
SELECT book_room(203, 6, '2021-06-12',3,'2021-06-11','2021-06-14','Cash',6,6);
SELECT book_room(303, 7, '2021-06-30',9,'2021-07-05','2021-07-14','paytm',7,7);
SELECT book_room(305, 8, '2021-07-27',1,'2021-08-19','2021-08-20','Card',8,8);



INSERT into BILL values(1,2400.00,'2021-08-20','Sachin','Tendulkar');
INSERT into BILL values(2,9900.00,'2021-07-14','Virat','Kohli');
INSERT into BILL values(3,12700.00,'2021-06-14','Rohit','Sharma');
INSERT into BILL values(4,17500.00,'2021-05-25','Gautham','Gambhir');
INSERT into BILL values(5,22500.00,'2021-04-29','MS','Dhoni');
INSERT into BILL values(6,9000.00,'2021-03-24','Smrithi','Mandhana');
INSERT into BILL values(7,15000.00,'2021-02-10','Mithali','Raj');
INSERT into BILL values(8,10000.00,'2021-01-17','Salman','Khan');


INSERT into ORDERS values(1,'Tomato','soup',150,2);
INSERT into ORDERS values(2,'Chilli','Chicken',250,1);
INSERT into ORDERS values(3,'Mutton','Biryani',300,1);
INSERT into ORDERS values(4,'Roti','Curry',100,3);
INSERT into ORDERS values(5,'Vegetable','salad',75,2);
INSERT into ORDERS values(6,'Tandoori','Chicken',350,2);
INSERT into ORDERS values(7,'Fish','Fry',280,3);
INSERT into ORDERS values(8,'Curd','Rice',125,1);


-- Simple Queries

SELECT* FROM EMPLOYEE;

SELECT* FROM bill;

DELETE FROM bill WHERE total_amt=2400;

DROP ROLE customer;

SELECT * FROM information_schema. table_privileges LIMIT 5;

-- Complex Queries

SELECT* FROM employee WHERE salary > 55000;

SELECT* FROM employee WHERE salary > 55000 and dno=1;

SELECT room_name, cost FROM room_type where cost>2000;

SELECT order_fname, order_lname FROM orders WHERE capacity>=2;

SELECT checkin, checkout FROM bookings where dur_of_stay<10;

SELECT checkin, total_amt FROM bookings where checkin>'2021-01-14';

--Nested Queries

SELECT gfname,glname FROM guests WHERE credit_info='visa'
ORDER BY gfname;

SELECT type_id,room_name FROM room_type WHERE pet_friendly=0
ORDER BY type_id;

SELECT COUNT (DISTINCT gid) FROM bookings
WHERE (checkin>='2021-05-20') OR
(checkout<='2021-10-15');

SELECT rooms.room_no, COUNT(rooms.r_type) AS COUNT from rooms
GROUP BY rooms.room_no;

SELECT bill_id,bill_fname,SUM(total_amt)
FROM bill
GROUP BY bill_id;

--User Access


CREATE user admin with encrypted password 'admin8055';

GRANT all privileges on database hotel_management to admin;



CREATE user Employee with encrypted password '123456';

GRANT SELECT on employee,department to Employee;



CREATE user Manager with encrypted password '909090';

GRANT INSERT,UPDATE on department,bookings,bill to Manager;



CREATE user Customer with encrypted password '10007';

GRANT INSERT,UPDATE on guests,rooms,room_type,orders,tables to Customer;

GRANT SELECT on bill,rooms_booked,bookings to Customer;


