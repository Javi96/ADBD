-- EJERCICIO 1
-- Apartado a)

CREATE OR REPLACE SEQUENCE SEQCambios
START WITH 1
INCREMENT BY 1;


create or replace trigger ModifSal
after update on Empleados of Salario
begin
	insert into Cambios
	values( SEQCambios.nextval, DNI, :OLD.Salario, :NEW.Salario)
end;

-- Apartado b)

-- EJERCICIO 2
-- Apartado a)

-- Apartado b)
create or replace trigger TotalBill

begin

end;


-- EJERCICIO 3


-- EJERCICIO 4


-- EJERCICIO 5
