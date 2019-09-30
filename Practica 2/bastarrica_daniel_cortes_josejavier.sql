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
/*
update Empleados
set Salario = 3000
where DNI in ('12345679B', '12345679C');
select * from Cambios; -- */

-- Apartado b)
/*
Escribir un procedimiento almacenado que liste por departamento el nombre y 
salario de cada empleado cuyo salario sea inferior a la media del departamento. 
Incluir el total de dichos salarios por departamento.
*/

create or replace procedure listaEmpDepart 
is
-- declare
Cursor CursorSalarios IS 
    Select Empleados.Nombre as empNom, Salario, Departamentos.Nombre as depNom
    from Empleados join Departamentos on Empleados.CodDept = Departamentos.CodDept
    -- group by CodDept, 
    where Salario < (
    	select avg(Salario)
    	from Empleados 
        where CodDept = Departamentos.CodDept
    	-- group by CodDept
    	)
    order by Departamentos.Nombre;
    
    totalDep Empleados.Salario%type := 0;
    lastDep Departamentos.Nombre%type := '';

begin

    DBMS_OUTPUT.PUT_LINE ('Emp, Sal, Dept');
    for regSal in CursorSalarios loop
         DBMS_OUTPUT.PUT_LINE (lastDep);
        if lastDep = '' then
            totalDep := 0;
            lastDep := regSal.depNom;
        end if;
    
        if lastDep = regSal.depNom then
            totalDep := totalDep + regSal.Salario;
        else
            DBMS_OUTPUT.PUT_LINE ( 'Total ' || lastDep || ': ' || totalDep );
            totalDep := regSal.Salario;
            lastDep := regSal.depNom;
        end if;
    
        DBMS_OUTPUT.PUT_LINE( regSal.empNom || ', ' || regSal.Salario || ', ' || regSal.depNom);
    end loop;
    DBMS_OUTPUT.PUT_LINE( 'Total departamento ' || lastDep || ': ' || totalDep );
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






----------------------------------------------------- EJERCICIO 2 -----------------------------------------------------
-- Apartado a)
/*
Escribir un procedimiento almacenado que reciba como argumentos una fecha, los códigos de un aeropuerto de origen 
y uno de destino y un pasaporte y registre un billete en el primer vuelo en el que haya plazas libres. En caso de
 que no haya vuelos disponibles se informará mediante un mensaje.
*/

-- Apartado b)
/*
Implementar un trigger que registre en la tabla Ventas el número total de billetes vendidos y el importe total de 
las ventas para cada vuelo. En el caso de devolución de un billete tan solo se reintegrará un importe fijo de 150€, 
no el importe total del billete.
*/

create or replace trigger TotalBill
after insert or delete
on table Billetes
declare
	Dinero 	number(6,2);
begin
	if inserting then
		Dinero := (
			select Importe 
			from Vuelo natural join Billetes 
			where Numero = :new.Numero and Fecha like :new.Fecha)
		update Ventas
		set Ventas.Importe += Dinero, Ventas.Vendidos += 1
		where :new.Numero = Ventas.Numero and :new.Fecha like Ventas.Fecha;
	end if;
	if deleting then
		update Ventas
		set Ventas.Importe -= 150, Ventas.Vendidos -= 1
		where :new.Numero = Ventas.Numero and :new.Fecha like Ventas.Fecha;
	end if;
end;


-- EJERCICIO 3


-- EJERCICIO 4


-- EJERCICIO 5
