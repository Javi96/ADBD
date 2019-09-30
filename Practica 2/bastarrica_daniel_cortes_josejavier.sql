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

create or replace NONEDITIONABLE procedure listaEmpDepart 
is
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
    
    emp_nom Empleados.Nombre%type := '';
    dep_nom Departamentos.Nombre%type := '';
    emp_sal Empleados.Salario%type := 0;
    
    total_dep Empleados.Salario%type := 0;
    last_dep Departamentos.Nombre%type;

begin
    
    for pointer in CursorSalarios loop
        emp_nom := pointer.empNom;
        dep_nom := pointer.depNom;
        emp_sal := pointer.Salario;
        
        if last_dep is null or last_dep = dep_nom then -- son del mismo departamento o es el primero de todos -> se acumula
            DBMS_OUTPUT.PUT_LINE(emp_nom || ' --- ' || dep_nom || ' --- ' || emp_sal);
            total_dep := total_dep + emp_sal;
        else
            DBMS_OUTPUT.PUT_LINE('TOTAL ' || last_dep || ' --- ' || total_dep);
            DBMS_OUTPUT.PUT_LINE(emp_nom || ' --- ' || dep_nom || ' --- ' || emp_sal);
            total_dep := emp_sal;
        
        end if;
        last_dep := dep_nom;
    end loop;
    DBMS_OUTPUT.PUT_LINE('TOTAL ' || last_dep || ' --- ' || total_dep);
end;



/*
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
*/





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
after insert on Billetes
for each row
declare
	Dinero 	number(6,2);
begin
    -- seleccionamos el precio del billete que hemos insertado
    select Vuelo.Importe into Dinero
    from Vuelo 
    where Vuelo.Numero = :new.Numero and Vuelo.Fecha like :new.Fecha;
    
    -- insertamos al informacion en la tabla de ventas
    insert into Ventas(Numero, Fecha, Importe, Vendidos)
    values(:new.Numero, :new.Fecha, Dinero, 1);
	
    /*if inserting then
    DBMS_OUTPUT.PUT_LINE('inserting');
        insert into Ventas(Numero, Fecha, Importe, Vendidos)
        values('vvvvva', '15/02/2019', 50, 1);
		Dinero := (
			select Importe 
			from Vuelo natural join Billetes 
			where Numero = :new.Numero and Fecha like :new.Fecha)
		update Ventas
		set Ventas.Importe += Dinero, Ventas.Vendidos += 1
		where :new.Numero = Ventas.Numero and :new.Fecha like Ventas.Fecha;
	end if;
	if deleting then
        DBMS_OUTPUT.PUT_LINE('deleting');
		update Ventas
		set Ventas.Importe -= 150, Ventas.Vendidos -= 1
		where :new.Numero = Ventas.Numero and :new.Fecha like Ventas.Fecha;
	end if;*/
end;


select * from Ventas;

-- EJERCICIO 3


-- EJERCICIO 4


-- EJERCICIO 5
