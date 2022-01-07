create or replace function printstudent()
returns int
language plpgsql
as
$$
declare
      c1 cursor for select * from student;
	  r1 record ;-- temporary location for storing the record from cursor for 
	                --manipulation
	   cnt int;
begin
    cnt:=0;
	open c1;
	fetch relative + 2 from c1 into r1;
	raise notice 'rollnumber: %',r1.roll;
	raise notice 'name: %',r1.name;
	raise notice 'marks: %',r1.marks;
	cnt:= cnt + 1;	
	
	--fetch last from c1 into r1;
	--raise notice 'rollnumber: %',r1.roll;
	--raise notice 'name: %',r1.name;
	--raise notice 'marks: %',r1.marks;
	--cnt:= cnt + 1;	
	
	close c1;
	return cnt;
end;
$$;