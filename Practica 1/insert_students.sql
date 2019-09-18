insert into catalog values
  ('csc226','Introduction to Programming I');
insert into catalog values
  ('csc227','Introduction to Programming II');
insert into catalog values
  ('csc343','Assembly Programming');
insert into catalog values
  ('csc481','Automata and Formal Languages');
insert into catalog values
  ('csc498','Introduction to Database Systems');
insert into catalog values
  ('csc880','Deductive Databases and Logic Programming');

insert into students values
  ('1111','Nandita','Rajshekhar','K');
insert into students values
  ('2222','Sydney','Corn','A');
insert into students values
  ('3333','Susan','Williams','B');
insert into students values
  ('4444','Naveen','Rajshekhar','B');
insert into students values
  ('5555','Elad','Yam','G');
insert into students values
  ('6666','Lincoln','Herring','F');

insert into courses values
  ('f96',1031,'csc226',90,80,65,50);
insert into courses values
  ('f96',1032,'csc226',90,80,65,50);
insert into courses values
  ('sp97',1031,'csc227',90,80,65,50);

insert into components values
  ('f96',1031,'exam1',100,30);
insert into components values
  ('f96',1031,'quizzes',80,20);
insert into components values
  ('f96',1031,'final',100,50);
insert into components values
  ('f96',1032,'programs',400,40);
insert into components values
  ('f96',1032,'midterm',100,20);
insert into components values
  ('f96',1032,'final',100,40);
insert into components values
  ('sp97',1031,'paper',100,50);
insert into components values
  ('sp97',1031,'project',100,50);

insert into enrolls values
  ('1111','f96',1031);
insert into enrolls values
  ('2222','f96',1031);
insert into enrolls values
  ('4444','f96',1031);
insert into enrolls values
  ('1111','f96',1032);
insert into enrolls values
  ('2222','f96',1032);
insert into enrolls values
  ('3333','f96',1032);
insert into enrolls values
  ('5555','sp97',1031);
insert into enrolls values
  ('6666','sp97',1031);

insert into scores values
  ('1111','f96',1031,'exam1',90);
insert into scores values
  ('1111','f96',1031,'quizzes',75);
insert into scores values
  ('1111','f96',1031,'final',95);
insert into scores values
  ('2222','f96',1031,'exam1',70);
insert into scores values
  ('2222','f96',1031,'quizzes',40);
insert into scores values
  ('2222','f96',1031,'final',82);
insert into scores values
  ('4444','f96',1031,'exam1',83);
insert into scores values
  ('4444','f96',1031,'quizzes',71);
insert into scores values
  ('4444','f96',1031,'final',74);
insert into scores values
  ('1111','f96',1032,'programs',400);
insert into scores values
  ('1111','f96',1032,'midterm',95);
insert into scores values
  ('1111','f96',1032,'final',99);
insert into scores values
  ('2222','f96',1032,'programs',340);
insert into scores values
  ('2222','f96',1032,'midterm',65);
insert into scores values
  ('2222','f96',1032,'final',95);
insert into scores values
  ('3333','f96',1032,'programs',380);
insert into scores values
  ('3333','f96',1032,'midterm',75);
insert into scores values
  ('3333','f96',1032,'final',88);
insert into scores values
  ('5555','sp97',1031,'paper',80);
insert into scores values
  ('5555','sp97',1031,'project',90);
insert into scores values
  ('6666','sp97',1031,'paper',80);
insert into scores values
  ('6666','sp97',1031,'project',85);
commit;
