drop database if exists procedures;

create database procedures;

use procedures;

create table tb_key
(
 id_key      integer primary key auto_increment,
 tx_key varchar(19) ,
 id_user integer
);

create table tb_user
(
	id_user integer primary key auto_increment,
	nm_user varchar(50)
);

alter table tb_key
add constraint FK_user_key foreign key (id_user) references tb_user (id_user) ;

ALTER TABLE tb_key
modify column id_user integer null;

ALTER TABLE tb_key
alter id_user set default null;

insert into tb_user(nm_user) values('astolfo');
insert into tb_user(nm_user) values('leao');
insert into tb_user(nm_user) values('virbreitos');
insert into tb_user(nm_user) values('nogrida');
insert into tb_user(nm_user) values('prifatos');
insert into tb_user(nm_user) values('astolfo');
insert into tb_user(nm_user) values('leao');
insert into tb_user(nm_user) values('virbreitos');
insert into tb_user(nm_user) values('nogrida');
insert into tb_user(nm_user) values('prifatos');
insert into tb_user(nm_user) values('nogrida');
insert into tb_user(nm_user) values('prifatos');

insert into tb_key(tx_key,id_user) values('frhgfdh',1);
insert into tb_key(tx_key,id_user) values('ffjhdh',3);
insert into tb_key(tx_key,id_user) values('ffjhdh',2);
insert into tb_key(tx_key,id_user) values('frhgfdh',4);
insert into tb_key(tx_key,id_user) values('ffjhdh',5);
insert into tb_key(tx_key,id_user) values('ffjhdh',7);
insert into tb_key(tx_key,id_user) values('frhgfdh',6);
insert into tb_key(tx_key,id_user) values('ffjhdh',9);
insert into tb_key(tx_key,id_user) values('ffjhdh',8);
insert into tb_key(tx_key,id_user) values('frhgfdh',11);
insert into tb_key(tx_key,id_user) values('ffjhdh',10);
insert into tb_key(tx_key,id_user) values('ffjhdh',12);
insert into tb_key(tx_key) values('fdhgfdhfdh');
insert into tb_key(tx_key) values('frgkhgh');
insert into tb_key(tx_key) values('frtrudjhgfdh');
insert into tb_key(tx_key) values('frgvbkh');
insert into tb_key(tx_key) values('frgkhgh');
insert into tb_key(tx_key) values('frtrudjhgfdh');
insert into tb_key(tx_key) values('frgvbkh');
insert into tb_key(tx_key) values('frgkhgh');
insert into tb_key(tx_key) values('frtrudjhgfdh');
insert into tb_key(tx_key) values('frgvbkh');
insert into tb_key(tx_key) values('frgkhgh');
insert into tb_key(tx_key) values('frtrudjhgfdh');
insert into tb_key(tx_key) values('frgvbkh');
insert into tb_key(tx_key) values('frgkhgh');
insert into tb_key(tx_key) values('frtrudjhgfdh');
insert into tb_key(tx_key) values('frgvbkh');
insert into tb_key(tx_key) values('frgkhgh');
insert into tb_key(tx_key) values('frtrudjhgfdh');
insert into tb_key(tx_key) values('frgkhgh');
insert into tb_key(tx_key) values('frtrudjhgfdh');
insert into tb_key(tx_key) values('frgvbkh');
insert into tb_key(tx_key) values('frgkhgh');
insert into tb_key(tx_key) values('frtrudjhgfdh');
insert into tb_key(tx_key) values('frgvbkh');
insert into tb_key(tx_key) values('frgkhgh');
insert into tb_key(tx_key) values('frtrudjhgfdh');
insert into tb_key(tx_key) values('frgvbkh');
insert into tb_key(tx_key) values('frgkhgh');
insert into tb_key(tx_key) values('frtrudjhgfdh');
insert into tb_key(tx_key) values('frgvbkh');
insert into tb_key(tx_key) values('frgvbkh');

DELIMITER $$
create procedure segundaTentativa (in min int,IN max int,IN pagina int)
begin
	set @total = null;
    set @contador =null;
    set @totalMaiorPagina = null;
    set @totalNotNullAtual = null;
    set @paginaMaiorUm = null;
    
	select @total := (select count(id_user) from tb_key where id_user is not null);
	select @contador := 1; 
    select @paginaMaiorUm := 0;

	if pagina > 1
	then
		select @paginaMaiorUm := 1;
		set min := 1 + min;
	end if;

	if pagina = 1
	then
		if (min / @contador) <= @total
        then
			select @totalMaiorPagina := 1;
		end if;
	end if;

	while @contador < pagina
	do
		if @totalMaiorPagina <> 1
        then
			if (min / @contador) <= (@total - (max / pagina ))
			then
				select @totalMaiorPagina := 1 ;
			end if;
		end if;
		select @contador := 1 + @contador;
	end while;

	with userNotNull as
	(
		select k.id_user,k.id_key, k.tx_key, u.nm_user, ROW_NUMBER() over(order by -k.id_user desc) as numeracao from tb_key k
		inner join tb_user u on u.id_user = k.id_user
		where k.id_user is not null
	)
	select @totalNotNullAtual := count(id_user) from userNotNull
	where numeracao between min and max;

	if @totalMaiorPagina = 1
	then
		with userNotNull as
		(
			select k.id_user,k.id_key, k.tx_key, u.nm_user, ROW_NUMBER() over(order by -k.id_user desc) as numeracao from tb_key k
			inner join tb_user u on u.id_user = k.id_user
			where k.id_user is not null
		)

		select * from userNotNull
		where numeracao between min and max
		order by id_key asc;

	
	else
		if @totalNotNullAtual > 0
		then 
			select 'caiu aqui'
			;with userNotNull as
			(
				select k.id_key, k.tx_key, u.nm_user, ROW_NUMBER() over(order by -k.id_user desc) as numeracao from tb_key k
				inner join tb_user u on u.id_user = k.id_user
				where k.id_user is not null
			)

			select * from userNotNull
			where numeracao between min and max
			order by id_key asc

			;with userNull as
			(
				select k.id_key,tx_key, (((min - @paginaMaiorUm) + @totalNotNullAtual) + ROW_NUMBER() over(order by -k.id_user desc)) as numeracao from tb_key k
				where k.id_user is null
			)

			select * from userNull
			where numeracao between (min + @totalNotNullAtual) and max
			order by id_key asc;
		else
			with userNull as
			(
				select k.id_key,k.tx_key,((min - @paginaMaiorUm) + ROW_NUMBER() over(order by -k.id_user desc)) as numeracao from tb_key k
				where k.id_user is null and k.id_key > (min - @paginaMaiorUm)
			)

			select * from userNull
			where numeracao between min and max
			order by id_key asc;
		end if;
	end if;
end $$
delimiter ;


call segundaTentativa (1,10,1);
call segundaTentativa (10,20,2);
call segundaTentativa (20,30,3);
call segundaTentativa (30,40,4);
call segundaTentativa (40,50,5);