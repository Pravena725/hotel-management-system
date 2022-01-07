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

create table rooms(
 room_id int PRIMARY KEY,
 room_no int,
 type varchar(255)
);

create table room_type(
 room_name varchar(255),
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
