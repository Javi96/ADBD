-- EJERCICIO 1

-- Apartado a)
/*
Implementar un trigger que registre en la tabla Cambios cualquier modificación 
que se produzca en el salario de un empleado, indicando el usuario en la que 
se realizó. El identificador se obtendrá de una secuencia denominada SEQCambios que debes crear.
*/

create sequence SEQCambios
start with 1
order;

create or replace trigger ModifSal
after update on Empleados
for each row
begin
    if :old.Salario != :new.Salario then
        insert into Cambios(IdCambio, Usuario, SalarioAnt, SalarioNew)
        values(SEQCambios.nextval, :old.DNI, :old.Salario, :new.Salario);
    end if;
end;

-- pruebas a)
update Empleados
set Salario = 3000
where DNI in ('12345679B', '12345679C');
select * from Cambios;

-- Apartado b)
/*
Escribir un procedimiento almacenado que liste por departamento el nombre y 
salario de cada empleado cuyo salario sea inferior a la media del departamento. 
Incluir el total de dichos salarios por departamento.
*/

create or replace procedure eje1_apab
    ( nombre OUT varchar ,
    	salario OUT number)
is
begin
    select distinct Nombre, Salario, sum(Salario)
    from Empleados join Departamentos using (CodDept)
    group by CodDept
    having Salario < (
    	select avg(Salario)
    	from Departamentos
    	group by CodDept
    	);
end;





select CodDept, Empleados.Salario, sum(Salario)
from Empleados join Departamentos using(CodDept)
group by CodDept, Empleados.Salario
having Salario < (
    select avg(e.Salario)
    from Empleados e
    where 11111 like e.CodDept
    group by e.CodDept
    );


select avg(e.Salario)
from Empleados e
group by e.CodDept;






-- EJERCICIO 2
-- Apartado a)

-- Apartado b)
create or replace trigger TotalBill

begin

end;


-- EJERCICIO 3


-- EJERCICIO 4


-- EJERCICIO 5
