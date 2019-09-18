insert into  zipcodes values
  (67226,'Wichita');
insert into  zipcodes values
  (60606,'Fort Dodge');
insert into  zipcodes values
  (50302,'Kansas City');
insert into  zipcodes values
  (54444,'Columbia');
insert into  zipcodes values
  (66002,'Liberal');
insert into  zipcodes values
  (61111,'Fort Hays');

insert into employees values
  (1000,'Jones',67226,to_date('12-12-1995'));
insert into employees values
  (1001,'Smith',60606,to_date('01-01-1992'));
insert into employees values
  (1002,'Brown',50302,to_date('01-09-94'));

insert into parts values
  (10506,'13GN3C10M030-1',200,19.99,20);
insert into parts values
  (10507,'PPJUSB021 USB JACK',156,19.99,20);
insert into parts values
  (10508,'1GB PC2700S 333MHz DDR CL2.5',190,19.99,20); 
insert into parts values
  (10509,'LHD HP 146GB SAS 10K 2.5',60,19.99,20);
insert into parts values
  (10601,'TOP FUSER COVER FU MFC9420',300,24.99,20);
insert into parts values
  (10701,'LAMP 3M X66',120,19.99,30);
insert into parts values
  (10800,'HP HINGE RIGTH G62',140,14.99,30);
insert into parts values
  (10900,'HP HINGE RIGTH P',100,24.99,30);

insert into customers values
  (1111,'Charles','123 Main St.',67226,'316-636-5555');
insert into customers values
  (2222,'Bertram','237 Ash Avenue',67226,'316-689-5555');
insert into customers values
  (3333,'Barbara','111 Inwood St.',60606,'316-111-1234');

insert into orders values
  (1020,1111,1000,'10-12-1994','12-12-1994');
insert into orders values
  (1021,1111,1000,'12-01-1995','15-01-1995');
insert into orders values
  (1022,2222,1001,'13-02-1995','20-02-1995');
insert into orders values
  (1023,3333,1000,'20-06-1997',null);

insert into odetails values
  (1020,10506,1);
insert into odetails values
  (1020,10507,1);
insert into odetails values
  (1020,10508,2);
insert into odetails values
  (1020,10509,3);
insert into odetails values
  (1021,10601,4);
insert into odetails values
  (1022,10601,1);
insert into odetails values
  (1022,10701,1);
insert into odetails values
  (1023,10800,1);
insert into odetails values
  (1023,10900,1);
