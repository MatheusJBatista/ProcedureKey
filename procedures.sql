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

go
insert into tb_key values('frhgfdh',1);
insert into tb_key values('ffjhdh',3);
insert into tb_key values('ffjhdh',2);
insert into tb_key values('frhgfdh',1);
insert into tb_key values('ffjhdh',3);
insert into tb_key values('ffjhdh',2);
insert into tb_key values('frhgfdh',1);
insert into tb_key values('ffjhdh',3);
insert into tb_key values('ffjhdh',2);
insert into tb_key values('frhgfdh',1);
insert into tb_key values('ffjhdh',3);
insert into tb_key values('ffjhdh',2);
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

go
alter procedure returnKeys @min int, @max int, @pagina int
as 
begin
	/*
	declare @contadorNovo int
	select @contadorNovo = 0
	*/
	if @pagina > 1
		select @min = @min +1

	declare @contador int
	;with numberKeysUserNN as
	(
		SELECT *, ROW_NUMBER() OVER (ORDER BY -id_key desc) as numeracao FROM tb_key
		where id_user is not null
	)
	select @contador = count(id_user)
	from numberKeysUserNN 
	where numeracao between @min and @max

	declare @contadorTotal int
	select @contadorTotal = (select count(id_user) from tb_key where id_user is not null)

	if @contador > @min and @max <= @contador
	begin
		;with numberKeysUserNN as
		(
			SELECT *, ROW_NUMBER() OVER (ORDER BY -id_key desc) as numeracao FROM tb_key
			where id_user is not null
		)
		select k.tx_key, u.nm_user,k.id_key
		from numberKeysUserNN k
		inner join tb_user u on k.id_user = u.id_user
		where numeracao between @min and @max
		/*
		if @contador < @max
		begin
			select @min = @min-1
			select @contador = @contador - @min
			;with numberKeysUserN as
			(
				SELECT *, ROW_NUMBER() OVER (ORDER BY -ID_USER desc) as numeracao FROM tb_key
				WHERE id_user is null
			)

			select id_key,tx_key
			from numberKeysUserN
			where numeracao between @min+1 and (@max - @contador)

			select @max - @contador
		end*/
	end
	else
	begin
	/*
		if @pagina > 1
			select @min = (@min - @contador)*/

		if @contador > 0
		begin
			;with numberKeysUserNN as
			(
				SELECT *, ROW_NUMBER() OVER (ORDER BY -id_key desc) as numeracao FROM tb_key
				where id_user is not null
			)
			select k.tx_key, u.nm_user, k.id_key
			from numberKeysUserNN k
			inner join tb_user u on k.id_user = u.id_user
			where numeracao between @min and @max
		end

		if (@max / @pagina) <= @contadorTotal
			select @min = 1
		else
		begin
			if(((@max / @pagina) - @contadorTotal) < 0)
				select @min = @min - (((@max / @pagina) - @contadorTotal)*-1)
			else
				select @min = @min - ((@max / @pagina) - @contadorTotal)
		end

		;with numberKeysUserN as
		(
			SELECT *, ROW_NUMBER() OVER (ORDER BY -id_key desc) as numeracao FROM tb_key
			WHERE id_user is null
		)

		select id_key,tx_key
		from numberKeysUserN
		where numeracao between @min and (@max - ((@max/@pagina)+@contador))

		/*
		select @contador
		select @min
		select @max
		select @max - @contador
		select @contadorNovo

		select @min - @contadorNovo
		select @max - @contador*/
		select @min, @max
	end
end

exec returnKeys 20,30,3

SELECT * FROM tb_key

SELECT * FROM tb_user

DELETE FROM TB_KEY