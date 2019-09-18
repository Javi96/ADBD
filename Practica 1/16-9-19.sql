-- Ej 1
Select pname
from parts
where price < 20 ;

-- Ej 2
Select ename, city
from ( ( ( employees natural join orders ) natural join odetails ) natural join parts ) natural join zipcodes
where price > 20 ;

-- Ej 3
select cname, city
from ( ( customers natural join orders ) natural join employees ) join zipcodes 
on employees.zip = zipcodes.zip
where zipcodes.city like 'Wichita' ;
