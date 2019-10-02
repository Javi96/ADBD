-------------------------------------- punto 1 --------------------------------------				--
drop table Empleados cascade constraints;
drop table Departamentos cascade constraints;
drop table Cambios cascade constraints;

CREATE TABLE Departamentos(
	CodDept CHAR(5) PRIMARY KEY, 
	Nombre VARCHAR(100));

CREATE TABLE Empleados( 
	DNI CHAR(9) PRIMARY KEY, 
	Nombre VARCHAR(100),
	CodDept CHAR(5) REFERENCES Departamentos on delete set NULL,
	Salario NUMBER(4,0));

CREATE TABLE Cambios(
	IdCambio VARCHAR(10) PRIMARY KEY, 
	Usuario VARCHAR(12), 
	SalarioAnt NUMBER(4,0),
	SalarioNew NUMBER(4,0));
    
insert into Departamentos values('11111', 'Departamento1');
insert into Departamentos values('22222', 'Departamento2');
insert into Departamentos values('33333', 'Departamento3');
        
insert into Empleados values('12345679A', 'Lucas', '11111', 1300);
insert into Empleados values('12345679B', 'Juan', '22222', 1500);
insert into Empleados values('12345679C', 'Marta', '22222', 2000);
insert into Empleados values('12345679D', 'Dani', '11111', 1900);
insert into Empleados values('12345679E', 'Rocio', '22222', 1800);
insert into Empleados values('12345679F', 'Sara', '33333', 1200);
insert into Empleados values('12345679G', 'Sonia', '33333', 1300);
insert into Empleados values('12345679H', 'Pablo', '11111', 1000);

commit;


-------------------------------------- punto 2 --------------------------------------
drop table Billetes cascade constraints;
drop table Ventas cascade constraints;
drop table Vuelo cascade constraints;
drop table Aeropuerto cascade constraints;

Create table Aeropuerto(
	Codigo CHAR(6) PRIMARY KEY,
	Nombre VARCHAR(30) NOT NULL,
	Pais VARCHAR(30)NOT NULL);


Create table Vuelo(
	Numero CHAR(6),
	Fecha DATE,
	Origen CHAR(6) NOT NULL REFERENCES Aeropuerto on delete set NULL,
	Destino CHAR(6) NOT NULL REFERENCES Aeropuerto on delete set NULL,
	Importe NUMBER(6,2),
	Plazas NUMBER(3) DEFAULT 100,

	primary key (numero,fecha),
	unique (fecha, origen, destino),
	check(origen<>destino));


Create table Billetes(
	Numero CHAR(6),
	Fecha DATE NOT NULL,
	Pasaporte CHAR(10) NOT NULL,

	PRIMARY KEY(Numero, fecha, pasaporte),
	FOREIGN KEY(Numero, fecha) REFERENCES vuelo);



Create table Ventas(
	Numero CHAR(6),
	Fecha DATE,
	Importe NUMBER(6,2),
	Vendidos NUMBER(3) DEFAULT 0,

	primary key (Numero, Fecha),
	foreign key (Numero, Fecha) REFERENCES Vuelo);


insert into Aeropuerto values('aaaaaa', 'Moncloa', 'Espania');
insert into Aeropuerto values('aaaaae', 'Goya', 'Paris');
insert into Aeropuerto values('aaaaai', 'Metropolitano', 'Londres');
insert into Aeropuerto values('aaaaao', 'CIU', 'Espania');
insert into Aeropuerto values('aaaaau', 'Carpetana', 'Chicago');
insert into Vuelo values('vvvvva', '15/02/2019', 'aaaaaa', 'aaaaae', 285.25, 50);
insert into Vuelo values('vvvvve', '16/02/2019', 'aaaaae', 'aaaaaa', 35.47, 50);
insert into Vuelo values('vvvvvi', '17/02/2019', 'aaaaaa', 'aaaaai', 415.36, 50);
insert into Vuelo values('vvvvvo', '18/02/2019', 'aaaaao', 'aaaaau', 256.69, 50);
insert into Vuelo values('vvvvvu', '19/02/2019', 'aaaaau', 'aaaaai', 369.58, 50);
commit;

insert into Billetes values('vvvvvi', '17/02/2019', '123456789C');
commit;
insert into Billetes values('vvvvva', '15/02/2019', '123456789A');
commit;
insert into Billetes values('vvvvva', '15/02/2019', '123456789C');
commit;
delete from Billetes where Numero = 'vvvvva'and Fecha = '15/02/2019' and Pasaporte = '123456789C';
commit;
delete from Billetes where Numero = 'vvvvva'and Fecha = '15/02/2019' and Pasaporte = '123456789A';
commit;
insert into Billetes values('vvvvve', '16/02/2019', '123456789C');
commit;
delete from Billetes where Numero = 'vvvvve'and Fecha = '16/02/2019' and Pasaporte = '123456789C';
commit;

insert into Vuelo values('vvvvvw', '15/02/2019', 'aaaaai', 'aaaaae', 285.25, 0);
commit;

-------------------------------------- punto 3 --------------------------------------				--

drop table ComisionCC;
drop table deposito;
drop table log;
create table ComisionCC(cc char(20), importe number(10,2));
create table deposito(cc char(20));
create table log( msg varchar(50));


insert into Comisioncc values ('12345678900987654321',13.9);
insert into Comisioncc values('12345123131333344321',13.0);
insert into Comisioncc values ('37423462487654321478',13.9);
insert into deposito values ('37423462487654321478');
delete from ComisionCC;


-------------------------------------- punto 4 --------------------------------------				--


drop table Records; 
drop table Marcas;
create table Records(prueba number primary key, tiempo number); 
create table Marcas(prueba number, fecha date, tiempo number, primary key (prueba,fecha));

delete from Records;
commit;
insert into Marcas values (1, to_date('01/02/2013'),3.8);
commit;
insert into Marcas values (1, to_date('02/02/2013'),4.2);
commit;
insert into Marcas values (1, to_date('03/02/2013'),3.5);
commit;

-------------------------------------- punto 5 --------------------------------------				--

drop table Ejemplares cascade constraints;
drop table Libros cascade constraints;

create table Libros(
	isbn char(13) primary key,
	copias integer);

create table Ejemplares(
	signatura char(5) primary key,
	isbn char(13) not null,
	
	FOREIGN KEY (isbn) REFERENCES Libros);
    
    
insert into Ejemplares values('ASDFD', 'ZZZXXXCCCVVVB');
commit;