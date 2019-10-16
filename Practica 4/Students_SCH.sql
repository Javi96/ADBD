drop table cataloge cascade constraints;
create table cataloge (
  cno       varchar2(7) not null,
  ctitle    varchar2(50),
  primary key (cno));
  
drop table students cascade constraints;
create table students (
  sid       varchar2(5) not null,
  fname     varchar2(20),
  lname     varchar2(20) not null,
  minit     char,
  primary key (sid));

drop table courses cascade constraints;
create table courses (
  term      varchar2(10) not null,
  lineno    number(4) not null,
  cno       varchar2(7) not null,
  a         number(2) check(a > 0),
  b         number(2) check(b > 0),
  c         number(2) check(c > 0),
  d         number(2) check(d > 0),
  primary key (term,lineno),
  foreign key (cno) references cataloge);

drop table components cascade constraints;
create table components (
  term      varchar2(10) not null,
  lineno    number(4) not null check(lineno >= 1000),
  compname  varchar2(15) not null,
  maxpoints number(4) check(maxpoints >= 0),
  weight    number(2) check(weight>=0),
  primary key (term,lineno,compname),
  foreign key (term,lineno) references courses);

drop table enrolls cascade constraints;
create table enrolls (
  sid       varchar2(5) not null,
  term      varchar2(10) not null,
  lineno    number(4) not null,
  primary key (sid,term,lineno),
  foreign key (sid) references students,
  foreign key (term,lineno) references courses);

drop table scores cascade constraints;
create table scores (
  sid       varchar2(5) not null,
  term      varchar2(10) not null,
  lineno    number(4) not null,
  compname  varchar2(15) not null,
  points    number(4) check(points >= 0),
  primary key (sid,term,lineno,compname),
  foreign key (sid,term,lineno) references enrolls,
  foreign key (term,lineno,compname) references components);

