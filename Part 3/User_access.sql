\c hotel_management;

CREATE user admin with encrypted password 'admin8055';

GRANT all privileges on database hotel_management to admin;



CREATE user Employee with encrypted password '123456';

GRANT SELECT on employee,department to Employee;



CREATE user Manager with encrypted password '909090';

GRANT INSERT,UPDATE on department,bookings,bill to Manager;



CREATE user Customer with encrypted password '10007';

GRANT INSERT,UPDATE on guests,rooms,room_type,orders,tables to Customer;

GRANT SELECT on bill,rooms_booked,bookings to Customer;

