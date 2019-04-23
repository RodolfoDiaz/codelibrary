create database MyClientDB;
use MyClientDB;
create table Client (
	id int not null,
    first_name varchar(100),
    last_name varchar(100)
    );
    
use MyClientDB;
select * from Client;
insert into Client values (1, 'Rodolfo', 'Diaz');