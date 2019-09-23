-- Nombres de partes que cuestan menos de 20 euros
select pname
from parts
where price < 20 
;

-- Nombres y ciudades de empleados que han realizado pedidos de piezas de precio superior a 20 euros
select distinct ename, city
from employees natural join orders  natural join odetails  natural join parts  natural join zipcodes
where price > 20 
;

-- Nombres de clientes que han solicitado piezas a empleados que viven en Wichita.
select distinct cname
from  ( ( orders  natural join employees) natural join zipcodes ) join customers using (cno)
where city like 'Wichita'
;

-- Nombres de clientes que solo han comprado a empleados de Wichita.
select distinct cname
from ((employees natural join orders) natural join  zipcodes) join customers using (cno)
where city like 'Wichita'
;

-- Nombres de clientes que han comprado todas las piezas de menos de 20 euros
select cname
from customers natural join orders natural join odetails natural join parts
where price < 20
group by cname, cno, pno
having count(*) = (select count(*) from parts where price < 20)
;

-- Nombres de empleados y sus totales de ventas en el año 1995.
select eno, ename , sum(qty*price) as total_ventas
from employees natural join orders natural join odetails natural join parts
where shipped >= '01/01/1995' and received <= '12/12/1995'
group by eno, ename
;

-- Nombres y numeros de los empleados que nunca han vendido a un cliente de su codigo postal
select eno, ename
from employees 
where employees.zip not in (
    select zip
    from employees natural join orders natural join customers
);

select distinct cname
from customers natural join orders 
group by cno, cname
having count(*) = (
    select max(count(*))
    from customers natural join orders
    group by cno, cname
)
;


select distinct cname
from customers natural join orders natural join odetails natural join parts
group by cno, cname, qty, price
having sum(qty*price) = (
    select max(sum(qty*price))
    from customers natural join orders natural join odetails natural join parts
    group by cno, cname, qty, price
)
;


select pname, count(*) as total
from orders natural join odetails natural join parts
group by pno, pname
order by count(*) desc
;



-- EJ 12 -- ok
-- Tiempo medio en número de días desde el envío de los pedidos hasta su recepción

select avg(to_date(shipped, 'DD/MM/YYYY') - to_date(received, 'DD/MM/YYYY')) as espera_time
from orders;


-- Numero de pedido y tiempo de espera de los pedidos de importe superior a 100 euros
select ono, to_date(shipped, 'DD/MM/YYYY') - to_date(received, 'DD/MM/YYYY') as espera_time
from orders natural join odetails natural join parts
where shipped is not null and received is not null
group by ono, to_date(shipped, 'DD/MM/YYYY') - to_date(received, 'DD/MM/YYYY')
having sum(qty*price) > 100;

-- reduce un 15% el precio de las piezas de coste inferior a 20 euros
select * from parts;
update parts
set price = price * 0.85
where price<20;


-- EJ 15 ok

select * from orders;
update orders
set shipped = sysdate
where shipped is null;


-- EJ 16 ok
-- disminuye 10 euros el precio de las piezas cuyo coste está por encima de la media

select * from parts;
update parts
set price = price - 10
where price > (
    select avg(price)
    from parts
);
--*/

-- borra todos los pedidos de los clientes de Wichita

delete 
from orders 
where orders.ono IN (
    select distinct ono
    from orders odrl natural join customers natural join zipcodes
    where city like 'Wichita'
);


-- borra los pedidos de los empleados que hayan realizado menos ventas (importe)
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





---------------------------- SEGUNDA PARTE - STUDENTS_SCH.SQL ----------------------------                       

-- 1) Identificador (sid) de los estudiantes que no se han matriculado en nada en el cuatrimestre f96.
select sid
from enrolls natural join students
group by sid, term
having term not like 'f96'
;

select * from cataloge natural join courses;

-- 2) Identificador (sid) de los estudiantes que se han matriculado en csc226 y csc227.
select sid
from (cataloge natural join courses) join (students natural join enrolls) using (term, lineno)
where cno in ('csc226', 'csc227')
group by sid, cno
having cno = all ('csc226', 'csc227')
;

-- 3) Identificador (sid) de los estudiantes que se han matriculado en todas las asignaturas.
select sid
from (cataloge natural join courses) join (students natural join enrolls) using (term, lineno)
group by sid, cno
having cno = all(
    select distinct cno
    from cataloge
)
; 

-- 4) Nombre de los estudiantes que se han matriculado en más asignaturas.
select fname, lname, count(*) as num_courses
from students natural join enrolls natural join courses natural join cataloge
group by sid, fname, lname
having count(*) = (
    select max(count(*))
    from students natural join enrolls natural join courses natural join cataloge
    group by sid, cno
)
;
               
-- 5) Nombre de los estudiantes que se han matriculado en menos asignaturas.
select fname, lname, count(*) as num_courses
from students natural join enrolls natural join courses natural join cataloge
group by sid, fname, lname
having count(*) = (
    select min(count(*))
    from students natural join enrolls natural join courses natural join cataloge
    group by sid, cno
)
;

-- 6) Nombre de los estudiantes que NO se han matriculado en ninguna asignatura.
select fname
from students natural join enrolls natural join courses natural join cataloge
group by sid, fname, lname
having count(*) = 0
;

-- 7) Asignaturas en las que se han matriculado 5 estudiantes o menos.
select distinct ctitle
from students natural join enrolls natural join courses natural join cataloge
group by cno, sid, ctitle
having count(*)<=5
;

-- 8) Mostrar el cuatrimestre, nombre de curso, línea y número junto con el número de matriculados.
select cno, ctitle, term,  lineno, count(sid) as enrollment
from students natural join enrolls natural join courses natural join cataloge
group by cno, term, ctitle, lineno
order by cno desc, lineno desc
;
