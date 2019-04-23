create database if not exists MyTestDB;
grant select on MyTestDB.* to testUser;
use MyTestDB;
create table Client (
	id int not null,
    first_name varchar(100),
    last_name varchar(100)
    );
    
use MyTestDB;
select * from Client;
insert into Client values (1, 'Rodolfo', 'Diaz');