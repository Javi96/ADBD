----------------------------------------------------- EJERCICIO 2 -----------------------------------------------------
-- Apartado a)
/*
Escribir un procedimiento almacenado que reciba como argumentos una fecha, los cÃ³digos de un aeropuerto de origen 
y uno de destino y un pasaporte y registre un billete en el primer vuelo en el que haya plazas libres. En caso de
 que no haya vuelos disponibles se informarÃ¡ mediante un mensaje.
*/

create or replace procedure RegistraBillete
    (in_fecha in Vuelo.Fecha%type,
    in_cod_origen in Vuelo.Origen%type,
    in_cod_destino in Vuelo.Destino%type,
    in_pasaporte in Billetes.Pasaporte%type)
is
    Cursor Vuelos is
        select Vuelo.Numero as vuelo_num 
        from Vuelo left join Ventas on Vuelo.Numero = Ventas.Numero and Vuelo.Fecha = Ventas.Fecha
        where coalesce( Ventas.Vendidos, 0) < Vuelo.Plazas and
            Vuelo.Fecha like in_fecha and 
            Vuelo.Origen like in_cod_origen and 
            Vuelo.Destino like in_cod_destino;

    v_numero Vuelo.Numero%type;

begin    
    open Vuelos;
    fetch Vuelos into v_numero;
    if Vuelos%FOUND then
        insert into Billetes 
        values(v_numero, in_fecha, in_pasaporte); 
    else
        DBMS_OUTPUT.PUT_LINE('no hay billetes');
    end if;
    close Vuelos;
end;

-- Apartado b)
/*
Implementar un trigger que registre en la tabla Ventas el nÃºmero total de billetes vendidos y el importe total de 
las ventas para cada vuelo. En el caso de devoluciÃ³n de un billete tan solo se reintegrarÃ¡ un importe fijo de 150â‚¬, 
no el importe total del billete.
*/


create or replace trigger TotalBill
after insert or delete on Billetes
for each row
declare
	Dinero 	number(6,2);
    check_value CHAR(6);
begin
    -- se ingresa un nuevo billete
    if inserting then
        -- seleccionamos el precio del billete que ha sido insertado
        select Vuelo.Importe into Dinero
        from Vuelo 
        where Vuelo.Numero = :new.Numero and Vuelo.Fecha like :new.Fecha;
        
        -- miramos si ese vuelo ya tenia billetes registrados
        select Numero into check_value
        from Ventas
        where Ventas.Numero = :new.Numero and Ventas.Fecha like :new.Fecha;
        
        -- actualizamos el registro con el incremento de import y una venta mas
        update Ventas
        set Importe = Importe + Dinero, Vendidos = Vendidos + 1
        where Ventas.Numero = :new.Numero and Ventas.Fecha = :new.Fecha;
    end if;
    -- se borra un billete
    if deleting then
        update Ventas
        set Importe = Importe - 150, Vendidos = Vendidos - 1
        where Ventas.Numero = :old.Numero and Ventas.Fecha = :old.Fecha;
    end if;
exception
    when no_data_found then
        insert into Ventas(Numero, Fecha, Importe, Vendidos)
        values(:new.Numero, :new.Fecha, Dinero, 1);
end;

-- EJERCICIO 4
/*
Diseñar un trigger asociado a la operación de inserción de la tabla Marcas, de modo que 
si el tiempo de la prueba que se inserte es un nuevo record se actualice el registro 
correspondiente en la tabla Records.
*/


create or replace trigger NewRecord
after insert on Marcas
for each row
declare
    id_record number;
    record_value number;
begin
    select prueba, tiempo into id_record, record_value
    from Records 
    where prueba = :new.prueba;
    
    if record_value < :new.tiempo then -- nuevo records, se actualiza registro
        update Records
        set tiempo = :new.tiempo
        where prueba = id_record;
    end if;
    
exception
    when no_data_found then
        insert into Records(prueba, tiempo)
        values(:new.prueba, :new.tiempo);
end;
