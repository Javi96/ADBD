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

create or replace NONEDITIONABLE procedure RegistraBillete
    (in_fecha in Vuelo.Fecha%type,
    in_cod_origen in Vuelo.Origen%type,
    in_cod_destino in Vuelo.Destino%type,
    in_pasaporte in Billetes.Pasaporte%type)
is
    Cursor Vuelos is
        select Vuelo.Numero as vuelo_num 
        from Vuelo join Ventas on Vuelo.Numero = Ventas.Numero and Vuelo.Fecha = Ventas.Fecha
        where Ventas.Vendidos < Vuelo.Plazas and
            rownum = 1 and 
            Vuelo.Fecha like in_fecha and 
            Vuelo.Origen like in_cod_origen and 
            Vuelo.Destino like in_cod_destino;

    v_numero Vuelo.Numero%type;

    empty_cursor Boolean := false;

begin
    DBMS_OUTPUT.PUT_LINE('hola ');
    for p_vuelo in Vuelos loop
        v_numero := p_vuelo.vuelo_num;
        insert into Billetes 
        values(v_numero, in_fecha, in_pasaporte); 
        commit;
        DBMS_OUTPUT.PUT_LINE('info: ' || v_numero || ' --- ' || in_fecha || ' --- ' || in_pasaporte || ' --- ');
        empty_cursor := true;
    end loop;
    
    if not empty_cursor then
        DBMS_OUTPUT.PUT_LINE('no hay billetes');
    end if;
end;

-- Apartado b)
/*
Implementar un trigger que registre en la tabla Ventas el número total de billetes vendidos y el importe total de 
las ventas para cada vuelo. En el caso de devolución de un billete tan solo se reintegrará un importe fijo de 150€, 
no el importe total del billete.
*/


create or replace trigger TotalBill
after insert or delete on Billetes
for each row
declare
	Dinero 	number(6,2);
    check_value number(1,0);
begin
    -- se ingresa un nuevo billete
    if inserting then
        -- seleccionamos el precio del billete que ha sido insertado
        select Vuelo.Importe into Dinero
        from Vuelo 
        where Vuelo.Numero = :new.Numero and Vuelo.Fecha like :new.Fecha;
        
        -- miramos si ese vuelo ya tenia billetes registrados
        select count(*) into check_value
        from Ventas
        where Ventas.Numero = :new.Numero and Ventas.Fecha like :new.Fecha;
        
        if check_value = 0 then -- no estaba insertado en la tabla
            -- insertamos al informacion en la tabla de ventas
            insert into Ventas(Numero, Fecha, Importe, Vendidos)
            values(:new.Numero, :new.Fecha, Dinero, 1);
        else
            -- actualizamos el registro con el incremento de import y una venta mas
            update Ventas
            set Importe = Importe + Dinero, Vendidos = Vendidos + 1
            where Ventas.Numero = :new.Numero and Ventas.Fecha = :new.Fecha;
        end if;    
	end if;
    -- se borra un billete
    if deleting then
        update Ventas
        set Importe = Importe - 150, Vendidos = Vendidos - 1
        where Ventas.Numero = :old.Numero and Ventas.Fecha = :old.Fecha;
    end if;
end;


select * from Ventas;
select * from Billetes;

-- EJERCICIO 3


-- EJERCICIO 4


-- EJERCICIO 5
