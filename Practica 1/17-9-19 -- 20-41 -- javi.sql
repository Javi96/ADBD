
-- Ej 1 ok
select pname
from parts
where price < 20 ;


-- preguntar si distinct o no?
-- Ej 2 ok
select ename, city
from employees natural join orders  natural join odetails  natural join parts  natural join zipcodes
where price > 20 ;

-- pendiente
-- Ej 3 no

select cname, city
from ( ( customers natural join orders ) natural join employees ) join zipcodes using (zip)
where zipcodes.city like 'Wichita' ;


-- EJ 4 ok
-- preguntar por que en este caso no puedo meter en el select cname

select cno, zip
from ((customers natural join orders) natural join employees) natural join zipcodes
group by cno, zip
having count(*) = 1;


-- EJ 5 ok

select cname
from customers natural join orders natural join odetails natural join parts
where price < 20
group by cname, cno, pno
having count(*) = (select count(*) from parts where price < 20)
;


-- EJ 6 ok
-- Nombres de empleados y sus totales de ventas en el año 1995.
select eno, ename , sum(qty*price) as total_ventas
from employees natural join orders natural join odetails natural join parts
where shipped >= '01/01/1995' and received <= '12/12/1995'
group by eno, ename
;


-- EJ 7 ok
-- Nombres y números de los empleados que nunca han vendido a un cliente de su código postal
select eno, ename
from employees 
where employees.zip not in (
    select zip
    from employees natural join orders natural join customers natural join zipcodes
);


-- EJ 8 ok

select distinct cname
from customers natural join orders
group by cno, cname
having count(*) = (
    select max(count(*))
    from customers natural join orders
    group by cno, cname
);


-- EJ 9 ok

select distinct cname
from customers natural join orders natural join odetails natural join parts
group by cno, cname, qty, price
having sum(qty*price) = (
    select max(sum(qty*price))
    from customers natural join orders natural join odetails natural join parts
    group by cno, cname, qty, price
);


-- EJ 10 ok


select pname, count(*) as total
from orders natural join odetails natural join parts

group by pno, pname
order by count(*) desc
;



-- EJ 12 -- ok
-- Tiempo medio en número de días desde el envío de los pedidos hasta su recepción
--/*
select * from orders;
select avg(to_date(shipped, 'DD/MM/YYYY') - to_date(received, 'DD/MM/YYYY')) as espera_time
from orders;
--*/


-- EJ 13 ok
--/* Numero de pedido y tiempo de espera de los pedidos de importe superior a 100 euros
select ono, trunc(to_date(shipped, 'DD/MM/YYYY')) - trunc(to_date(received, 'DD/MM/YYYY')) as espera_time, sum(qty*price)
from orders natural join odetails natural join parts
where shipped is not null and received is not null
group by ono, trunc(to_date(shipped, 'DD/MM/YYYY')) - trunc(to_date(received, 'DD/MM/YYYY'))
having sum(qty*price) > 100;
--*/

-- EJ 14 ok
-- reduce un 15% el precio de las piezas de coste inferior a 20 euros
--/*
select * from parts;
update parts
set price = price * 0.85
where price<20;
--*/


-- EJ 15 ok

---/* 
select * from orders;
update orders
set shipped = sysdate
where shipped is null;
--*/


-- EJ 16 ok
-- disminuye 10 euros el precio de las piezas cuyo coste está por encima de la media

--/* 
select * from parts;
update parts
set price = price - 10
where price > (
    select avg(price)
    from parts
);
--*/

-- EJ 17 no sale y no veo por que no
-- borra todos los pedidos de los clientes de Wichita

delete 
from orders 
where orders.ono IN (
    select distinct ono
    from orders odrl natural join customers natural join zipcodes
    where city like 'Wichita'
);
-- 
select distinct ono
from orders odrl natural join customers natural join zipcodes
where city like 'Wichita'
;

-- EJ 18
-- borra los pedidos de los empleados que hayan realizado menos ventas (importe)
-- la query de dentro funciona, pero no borra
--/*

delete 
from orders ord1
where ord1.ono in (
    select ord.ono
    from orders ord join odetails on ord.ono = odetails.ono 
        join employees on ord.eno = employees.eno 
        join parts on parts.pno = odetails.pno
    group by employees.eno, ord.ono
    having sum(qty*price) = (
        select min(sum(qty*price))
        from orders natural join odetails natural join employees natural join parts
        group by eno, ono)
);
--*/






---------------------------- SEGUNDA PARTE - STUDENTS_SCH.SQL ----------------------------                       

-- 1) Identificador (sid) de los estudiantes que no se han matriculado en nada en el cuatrimestre f96.
select sid
from enrolls natural join students
group by sid, term
having term not like 'f96'
;

-- 2) Identificador (sid) de los estudiantes que se han matriculado en csc226 y csc227.
select sid
from (catalog natural join courses) join (students natural join enrolls) using (term, lineno)
--group by sid
group by sid, cno
having cno = all ('csc226', 'csc227')
;

-- 3) Identificador (sid) de los estudiantes que se han matriculado en todas las asignaturas.
-- 4) Nombre de los estudiantes que se han matriculado en más asignaturas.
-- 5) Nombre de los estudiantes que se han matriculado en menos asignaturas.
-- 6) Nombre de los estudiantes que NO se han matriculado en ninguna asignatura.
-- 7) Asignaturas en las que se han matriculado 5 estudiantes o menos.
-- 8) Mostrar el cuatrimestre, nombre de curso, línea y número junto con el número de matriculados.










