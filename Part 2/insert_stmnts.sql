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




INSERT into ROOMS values(1, 101, 'Single');
INSERT into ROOMS values(2, 102, 'Double');
INSERT into ROOMS values(3, 103, 'Double');
INSERT into ROOMS values(4, 104, 'Single');
INSERT into ROOMS values(5, 201, 'Single');
INSERT into ROOMS values(6, 201, 'Double');
INSERT into ROOMS values(7, 203, 'Triple');
INSERT into ROOMS values(8, 301, 'Double');
INSERT into ROOMS values(9, 302, 'Queen');
INSERT into ROOMS values(10, 303, 'Triple');
INSERT into ROOMS values(11, 304, 'Single');
INSERT into ROOMS values(12, 305, 'Double');


INSERT into ROOM_TYPE values('Single', 21, 1200.00,'A room assigned to one person.', 0);
INSERT into ROOM_TYPE values('Double', 22, 2000.50,'A room assigned to two people', 0);
INSERT into ROOM_TYPE values('Triple', 23, 3500.25,'A room that can accommodate three persons', 1);
INSERT into ROOM_TYPE values('Queen', 24, 5000.00,'A room with a queen-sized bed. May be occupied by one or more people.', 1);
INSERT into ROOM_TYPE values('Single+Balcony', 25, 1500.00,'A room assigned to one person with a balcony', 0);
INSERT into ROOM_TYPE values('Single+lakeview', 26, 1800.00,'A room assigned to one person with a beautiful view of the lake', 1);
INSERT into ROOM_TYPE values('Double+Balcony', 27, 2300.00,'A room assigned to two people with a balcony', 0);
INSERT into ROOM_TYPE values('Double+lakeview', 28, 2800.00,'A room assigned to two people with a beautiful view of the lake', 1);


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



INSERT into BOOKINGS values(100,'2021-01-10',3,'2021-01-14','2021-01-17','Card',1,1,10000.00);
INSERT into BOOKINGS values(101,'2021-01-25',8,'2021-02-02','2021-02-10','Cash',2,2,15000.00);
INSERT into BOOKINGS values(102,'2021-03-10',2,'2021-03-22','2021-03-24','paytm',3,3,9000.00);
INSERT into BOOKINGS values(103,'2021-04-12',11,'2021-04-18','2021-04-29','Card',4,4,22500.00);
INSERT into BOOKINGS values(104,'2021-05-18',5,'2021-05-20','2021-05-25','Cash',5,5,17500.00);
INSERT into BOOKINGS values(105,'2021-06-12',3,'2021-06-11','2021-06-14','Cash',6,6,12700.00);
INSERT into BOOKINGS values(106,'2021-06-30',9,'2021-07-05','2021-07-14','paytm',7,7,9900.00);
INSERT into BOOKINGS values(107,'2021-07-27',1,'2021-08-19','2021-08-20','Card',8,8,2400.00);



INSERT into ROOMS_BOOKED values(1, 100, 1);
INSERT into ROOMS_BOOKED values(2, 101, 2);
INSERT into ROOMS_BOOKED values(3, 102, 3);
INSERT into ROOMS_BOOKED values(4, 103, 4);
INSERT into ROOMS_BOOKED values(5, 104, 5);
INSERT into ROOMS_BOOKED values(6, 105, 6);
INSERT into ROOMS_BOOKED values(7, 106, 7);
INSERT into ROOMS_BOOKED values(8, 107, 8);



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







