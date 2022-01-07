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