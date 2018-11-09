use master

go
drop database procedures

go
create database procedures

go
use procedures

go
create table tb_key
(
 id_key      integer primary key identity,
 tx_key varchar(19) ,
 id_jogador integer
);

go
create table tb_user
(
	id_user integer primary key identity,
	nm_user varchar(50)
);


go
exec sp_rename 'tb_key.id_jogador' , 'id_user'

go
alter table tb_key
add constraint FK_user_key foreign key (id_user) references tb_user (id_user) 

go
ALTER TABLE tb_key
alter column id_user integer null

go
ALTER TABLE tb_key
add constraint user_default 
default null
for id_user


go
insert into tb_user values('astolfo')
insert into tb_user values('leao')
insert into tb_user values('virbreitos')
insert into tb_user values('nogrida')
insert into tb_user values('prifatos')
insert into tb_user values('astolfo')
insert into tb_user values('leao')
insert into tb_user values('virbreitos')
insert into tb_user values('nogrida')
insert into tb_user values('prifatos')
insert into tb_user values('nogrida')
insert into tb_user values('prifatos')

go
insert into tb_key values('frhgfdh',1);
insert into tb_key values('ffjhdh',3);
insert into tb_key values('ffjhdh',2);
insert into tb_key values('frhgfdh',4);
insert into tb_key values('ffjhdh',5);
insert into tb_key values('ffjhdh',7);
insert into tb_key values('frhgfdh',6);
insert into tb_key values('ffjhdh',9);
insert into tb_key values('ffjhdh',8);
insert into tb_key values('frhgfdh',11);
insert into tb_key values('ffjhdh',10);
insert into tb_key values('ffjhdh',12);
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

alter procedure segundaTentativa @min int, @max int, @pagina int
as
begin
	declare @total int, @contador int, @totalMaiorPagina bit, @totalNotNullAtual int, @paginaMaiorUm bit
	select @total = count(id_user) from tb_key where id_user is not null
	select @contador = 1, @paginaMaiorUm = 0

	if @pagina > 1
	begin
		select @paginaMaiorUm = 1
		select @min += 1
	end

	if @pagina = 1
	begin
		if @min / @contador <= @total
			select @totalMaiorPagina = 1
	end

	while @contador < @pagina
	begin
		if @min / @contador <= (@total - (@max / @pagina ))
			select @totalMaiorPagina = 1 break
		select @contador += 1
	end

	;with userNotNull as
	(
		select k.id_user,k.id_key, k.tx_key, u.nm_user, ROW_NUMBER() over(order by -k.id_user desc) as numeracao from tb_key k
		inner join tb_user u on u.id_user = k.id_user
		where k.id_user is not null
	)

	select @totalNotNullAtual = count(id_user) from userNotNull
	where numeracao between @min and @max

	if @totalMaiorPagina = 1
	begin
		;with userNotNull as
		(
			select k.id_user,k.id_key, k.tx_key, u.nm_user, ROW_NUMBER() over(order by -k.id_user desc) as numeracao from tb_key k
			inner join tb_user u on u.id_user = k.id_user
			where k.id_user is not null
		)

		select * from userNotNull
		where numeracao between @min and @max
		order by id_key asc

	end
	else
	begin
		if @totalNotNullAtual > 0
		begin 
			select 'caiu aqui'
			;with userNotNull as
			(
				select k.id_key, k.tx_key, u.nm_user, ROW_NUMBER() over(order by -k.id_user desc) as numeracao from tb_key k
				inner join tb_user u on u.id_user = k.id_user
				where k.id_user is not null
			)

			select * from userNotNull
			where numeracao between @min and @max
			order by id_key asc

			;with userNull as
			(
				select k.id_key,tx_key, (((@min - @paginaMaiorUm) + @totalNotNullAtual) + ROW_NUMBER() over(order by -k.id_user desc)) as numeracao from tb_key k
				where k.id_user is null
			)

			select * from userNull
			where numeracao between (@min + @totalNotNullAtual) and @max
			order by id_key asc
		end
		else
		begin
			;with userNull as
			(
				select k.id_key,k.tx_key,((@min - @paginaMaiorUm) + ROW_NUMBER() over(order by -k.id_user desc)) as numeracao from tb_key k
				where k.id_user is null and k.id_key > (@min - @paginaMaiorUm)
			)

			select * from userNull
			where numeracao between @min and @max
			order by id_key asc
		end
	end
end

exec segundaTentativa 1,10,1
exec segundaTentativa 10,20,2
exec segundaTentativa 20,30,3
exec segundaTentativa 30,40,4
exec segundaTentativa 40,50,5
