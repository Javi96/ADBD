/*
-- Ej 1 ok
select pname
from parts
where price < 20 ;
*/

/*
-- Ej 2 ok
select ename, city
from employees natural join orders  natural join odetails  natural join parts  natural join zipcodes
where price > 20 ;
*/

-- Ej 3 no
/*
select cname, city
from ( ( customers natural join orders ) natural join employees ) join zipcodes 
on employees.zip = zipcodes.zip
where zipcodes.city like 'Wichita' ;
*/

-- EJ 4 ok
-- preguntar por que en este caso no puedo meter en el select cname
/*
select cno, zip
from ((customers natural join orders) natural join employees) natural join zipcodes
group by cno, zip
having count(*) = 1;
*/

-- EJ 5 ok
/*
select cname
from customers natural join orders natural join odetails natural join parts
where price < 20
group by cname, cno, pno
having count(*) = (select count(*) from parts where price < 20)
;
*/

-- EJ 6 -- a medias
/*
select sum(qty*price) as total
from employees natural join orders natural join odetails natural join parts
where shipped >= '01/01/1995' and received <= '12/12/1995'
group by ono, qty, price
;
*/

-- EJ 7 ok
/*
select eno, ename
from employees 
where employees.zip not in (
    select zip
    from employees natural join orders natural join customers natural join zipcodes
);
*/

-- EJ 8 ok
/*
select distinct cno, cname, count(*)
from customers natural join orders
group by cno, cname
having count(*) = (
    select max(count(*))
    from customers natural join orders
    group by cno, cname
)
*/

-- EJ 9 ok
/*
select distinct cno, cname, sum(qty*price)
from customers natural join orders natural join odetails natural join parts
group by cno, cname, qty, price
having sum(qty*price) = (
    select max(sum(qty*price))
    from customers natural join orders natural join odetails natural join parts
    group by cno, cname, qty, price
);
*/

-- EJ 10 ok

/*
select pno, pname, count(*)
from orders natural join odetails natural join parts

group by pno, pname
order by count(*) desc
;
*/


-- EJ 12
/*
select * from orders;
select avg(trunc(to_date(shipped, 'DD/MM/YYYY')) - trunc(to_date(received, 'DD/MM/YYYY'))) as avg_days
from orders;
*/


-- EJ 13 ok
/*
select ono, trunc(to_date(shipped, 'DD/MM/YYYY')) - trunc(to_date(received, 'DD/MM/YYYY')) as days, sum(qty*price)
from orders natural join odetails natural join parts
where shipped is not null and received is not null
group by ono, trunc(to_date(shipped, 'DD/MM/YYYY')) - trunc(to_date(received, 'DD/MM/YYYY'))
having sum(qty*price) > 100;
*/

-- EJ 14 ok
-- reduce un 15% el precio de las piezas de coste inferior a 20 euros
/*
update parts
set price = price - price*0.15
where price<20;
*/


-- EJ 15 ok

/*
update orders
set shipped = sysdate
where shipped is null;
*/


-- EJ 16 ok
-- disminuye 10 euros el precio de las piezas cuyo coste está por encima de la media

/*
update parts
set price = price - 10
where price > (
    select avg(price)
    from parts
);
*/

-- EJ 17 no sale y no veo por que no
-- borra todos los pedidos de los clientes de Wichita

delete 
from orders 
where orders.ono = any(
    select odr1.ono
    from orders odr1 join customers using (cno) join zipcodes using (zip)
    where zipcodes.city like 'Wichita'
    group by odr1.ono
);
-- esta query funciona pero no se como hacer el delete :D
select odr1.ono
from orders odr1 join customers using (cno) join zipcodes using (zip)
where zipcodes.city like 'Wichita'
group by odr1.ono
;

-- EJ 18
-- borra los pedidos de los empleados que hayan realizado menos ventas (importe)
-- la query de dentro funciona, pero no borra
/*
delete 
from orders ord1
where ord1.ono like (
    select ord.ono
    from orders ord join odetails on ord.ono = odetails.ono join employees on ord.eno = employees.eno join parts on parts.pno = odetails.pno
    group by employees.eno, ord.ono
    having sum(qty*price) = (
        select min(sum(qty*price))
        from orders natural join odetails natural join employees natural join parts
        group by eno, ono
        having sum(qty*price) > 0)
);
*/



---------------------------- SEGUNDA PARTE - STUDENTS_SCH.SQL ----------------------------                       

-- 1) Identificador (sid) de los estudiantes que no se han matriculado en nada en el cuatrimestre f96.
select sid, term
from enrolls natural join students
group by sid, term
having term not like 'f96'
;

-- 2) Identificador (sid) de los estudiantes que se han matriculado en csc226 y csc227.
select sid, cno
from (cataloge natural join courses natural join components) join (students natural join enrolls) using (term, lineno)
group by sid, cno
--group by sid, cno
--having cno in ('csc226', 'csc227')

;
-- 3) Identificador (sid) de los estudiantes que se han matriculado en todas las asignaturas.
-- 4) Nombre de los estudiantes que se han matriculado en más asignaturas.
-- 5) Nombre de los estudiantes que se han matriculado en menos asignaturas.
-- 6) Nombre de los estudiantes que NO se han matriculado en ninguna asignatura.
-- 7) Asignaturas en las que se han matriculado 5 estudiantes o menos.
-- 8) Mostrar el cuatrimestre, nombre de curso, línea y número junto con el número de matriculados.










