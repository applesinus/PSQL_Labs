create schema db

create table db.sellers (
    snum integer primary key,
    sname varchar not null,
    city varchar not null,
    comm decimal
);
insert into db.sellers values
(1001, 'Peel', 'London', .12),
(1002, 'Serres', 'San Jose', .13),
(1004, 'Motika', 'London', .11),
(1007, 'Rifkin', 'Barcelona', .15),
(1003, 'Axelrod', 'London', .10);

create table db.customers (
    cnum integer primary key,
    cname varchar not null,
    city varchar not null,
    rating integer not null,
    snum integer not null,
    foreign key (snum) references db.sellers(snum)
);
insert into db.customers values
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanni', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 200, 1002),
(2004, 'Grass', 'Berlin', 300, 1002),
(2006, 'Clemens', 'London', 100, 1001),
(2008, 'Cisneros', 'San Jose', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004);

create table db.orders (
    onum integer primary key,
    amt decimal not null,
    odate date not null,
    cnum integer not null,
    snum integer not null,
    foreign key (cnum) references db.customers(cnum),
    foreign key (snum) references db.sellers(snum)
);
insert into db.orders values
(3001, 18.69, date '1990-10-03', 2008, 1007),
(3003, 767.19, date '1990-10-03', 2001, 1001),
(3002, 1900.10, date '1990-10-03', 2007, 1007),
(3005, 5160.45, date '1990-10-03', 2003, 1002),
(3006, 1098.16, date '1990-10-03', 2008, 1007),
(3009, 1713.23, date '1990-10-04', 2002, 1003),
(3007, 75.75, date '1990-10-04', 2004, 1002),
(3008, 4723.00, date '1990-10-05', 2006, 1001),
(3010, 1309.95, date '1990-10-06', 2004, 1002),
(3011, 9891.88, date '1990-10-06', 2006, 1001);


/* JUST IN CASE */
select * from db.customers;
select * from db.sellers;
select * from db.orders;

drop table db.orders;
drop table db.customers;
drop table db.sellers;


/*  LAB 1   */
select * from db.orders where odate = date '1990-10-3';
select * from db.orders where odate = date '1990-10-4';

select * from db.customers where snum in (select snum from db.sellers where sname in ('Peel', 'Motika'));

select * from db.customers where cname between 'A' and 'G';

select * from db.customers where cname like 'G%';

select * from db.orders where amt is NULL;


/*  LAB 2   */
select sum(amt) from db.orders where odate = date '1990-10-3';

select count(distinct city) from db.customers where not city is null;

select cnum, min(amt) from db.orders group by cnum;

select cname from db.customers where cname like 'G%' order by cname asc;

select city, max(rating) from db.customers group by city;

/*
ЗАДАНИЕ 2.6: Напишите запрос, который сосчитал бы число заказчиков, регистрирующих каждый день свои заказы.
(Если продавец имел более одного заказа в данный день, он должен учитываться только один раз.)

ВОПРОС: Я так понял, что имелось в виду количество продавцов, иначе зачем вводить проверку на уникальность?
Если это так, то запрос имеет вид:
*/
select odate, count(distinct snum) from db.orders group by odate;


/*  LAB 3   */
select onum, snum, amt * .12 from db.orders;

select 'For the city', city, ', the highest rating is: ', max(rating), '.' from db.customers group by city;

/*
ЗАДАНИЕ 3.3: Напишите запрос, который выводил бы список заказчиков в нисходящем порядке.
Вывод поля оценки/рейтинга (rating) должен сопровождаться именем заказчика и его номером.

ВОПРОС: Выводиться должна информация по нисходящей оценке, иначе почему именно оценка сопровождается именем и номером?
Если это так, то запрос имеет вид:
*/
select rating, cname, cnum from db.customers order by rating desc;

/*
ЗАДАНИЕ 3.4: Напишите запрос, который выводил бы общие заказы на каждый день и помещал результаты в нисходящем порядке.

ВОПРОС: Я так полагаю, общие заказы - это сумма всех заказов за день и именно по ней сортировать?
Если это так, то запрос имеет вид:
*/
select odate, sum(amt) from db.orders group by odate order by sum(amt) desc;


/*  LAB 4   */
select onum, cname from db.orders, db.customers where db.customers.cnum = db.orders.cnum;

select onum, cname, sname from db.orders, db.customers, db.sellers where
                                                    db.customers.cnum = db.orders.cnum and db.orders.snum = db.sellers.snum;

select cname, sname, comm from db.sellers, db.customers, db.orders
                          where db.sellers.comm > .12
                            and db.sellers.snum = db.orders.snum
                            and db.orders.cnum = db.customers.cnum;

select distinct sname, comm from db.customers, db.sellers, db.orders
                   where db.customers.rating > 100
                     and db.customers.snum = db.sellers.snum;


/*  LAB 5   */
select * from db.orders where cnum = (select cnum from db.customers where cname = 'Cisneros');

/*  5.2 'усредненные заказы'?  */

select sum, snum from (select sum(amt), snum from db.orders group by snum) as a where sum > (select max(amt) from db.orders);

select cnum, cname from (select * from db.customers as "outer" where ("outer".rating, "outer".city) in (select max("inner".rating), "inner".city from db.customers as "inner" group by "inner".city)) as result;

select snum, sname from db.sellers as a where a.snum != any(select snum from db.customers as b where a.city = b.city);


/*  LAB 6   */
select sname from db.sellers as a where exists (select cname from db.customers as b where a.snum = b.snum and b.rating = 300);

/* 6.2 никак, юнион не предназначен для этого. */

select sname from db.sellers as a where exists (select cname from db.customers as b where a.city = b.city and a.snum != b.snum);

select cname from db.customers as a where
                                        exists(select cname from db.customers as b where
                                                                                       a.snum = b.snum and
                                                                                       a.cnum != b.cnum and
                                                                                       exists(select onum from db.orders as c where b.cnum = c.cnum));

select cname
from db.customers as a
where a.rating > any (select rating
                      from db.customers as b
                      where b.snum = (select snum
                                      from db.sellers as c
                                      where c.sname = 'Serres'
                                      )
                      );

/* 6.6 "Что будет выведено вышеупомянутой командой?" - видимо, ничего, раз нет команды. */

select sname
from db.sellers as a
where a.city != all(select city
                    from db.customers as b
                    where b.snum = a.snum
                    );

select onum, amt
from db.orders as a
where a.amt >= any(select amt
                   from db.orders as b
                   where b.cnum = any(select cnum
                                      from db.customers as c
                                      where c.city = 'London'
                                      )
                   );

/* 6.9 - сравнение идёт с любой суммой, так что логично использовать min, а не max, разве нет? */
select onum, amt
from db.orders as a
where a.amt >= (select min(amt)
                   from db.orders as b
                   where b.cnum = any(select cnum
                                      from db.customers as c
                                      where c.city = 'London'
                                      )
                   );

/*  LAB 7   */
select cname, city, rating, 'Высокий Рейтинг' as "comment" from db.customers where rating >= 200
union
select cname, city, rating, 'Низкий Рейтинг' as "comment" from db.customers where rating < 200;

select cnum, cname as "name"
from db.customers as a
where 1 < (select count(onum)
          from db.orders as b
          where a.cnum = b.cnum)
union
select snum, sname as "name"
from db.sellers as a
where 1 < (select count(onum)
          from db.orders as b
          where a.snum = b.snum)
order by "name";

select snum as "num" from db.sellers where city = 'San Jose'
union
(
select cnum as "num" from db.customers where city = 'San Jose'
union all
select onum as "num" from db.orders where odate = date '1990-10-03'
);

/*  LAB 8   */
select * from db.sellers;
insert into db.sellers values (1100, 'Bianco', 'San Jose', null);
delete from db.sellers where snum = 1100;

select * from db.orders;
delete from db.orders where cnum = (select cnum from db.customers where cname = 'Clemens');
insert into db.orders values
(3008, 4723.00, date '1990-10-05', 2006, 1001),
(3011, 9891.88, date '1990-10-06', 2006, 1001);

select * from db.customers;
update db.customers set rating = rating+100 where city = 'Rome';
update db.customers set rating = rating-100 where city = 'Rome';

select * from db.customers;
update db.customers
set snum = (select snum from db.sellers where sname ='Motika')
where snum = (select snum from db.sellers where sname ='Serres');
update db.customers set snum = 1002 where cnum = 2003;
update db.customers set snum = 1002 where cnum = 2004;

/*  LAB 9.1   */
create table db.multicust (
    snum integer primary key,
    sname varchar not null,
    city varchar not null,
    comm decimal
);
select * from db.multicust;

insert into db.multicust
    (select *
     from db.sellers
     where snum in (select snum
                    from db.orders
                    group by snum
                    having count(onum) > 1
                    )
     );
select * from db.multicust;

drop table db.multicust;

/*  LAB 9.2,9.3   */
select * from db.customers;
delete from db.customers where cnum not in (select distinct cnum from db.orders);
select * from db.customers;

select * from db.sellers;
update db.sellers
set comm = comm + .2
where snum in (select snum
               from db.orders
               group by snum
               having sum(amt) > 3000
              );
select * from db.sellers;
update db.sellers
set comm = comm - .2
where snum in (select snum
               from db.orders
               group by snum
               having sum(amt) > 3000
              );

/*  LAB 10  */
create table db.customers (
    cnum integer primary key,
    cname varchar not null,
    city varchar not null,
    rating integer not null,
    snum integer not null,
    foreign key (snum) references db.sellers(snum)
);

select * from db.orders order by odate;

alter table db.orders add constraint onum_unique unique (onum);

create unique index snum_index on db.orders (snum);

/*
10.5 - пусть данные значения - 100 и Motika.
я знаю, что это делается через хранимые функции,
но типа их в этом курсе как будто бы нет
*/
select cname
from db.customers as a
where cnum = (select cnum
              from db.customers as b
              where b.rating = 100 and
                    b.snum = 'Motika');

/*  LAB 11  */
create table db.orders (
    onum integer primary key,
    amt decimal,
    odate date not null,
    cnum integer,
    snum integer,
    foreign key (cnum) references db.customers(cnum),
    foreign key (snum) references db.sellers(snum),
    constraint unique_cnum_and_snum unique (cnum, snum)
);

create table db.sellers (
    snum integer primary key,
    sname varchar not null check (sname between 'A' and 'M' ),
    city varchar not null,
    comm decimal default .1
);

create table db.orders (
    onum integer primary key,
    amt decimal,
    odate date not null,
    cnum integer not null check (cnum < onum),
    snum integer not null check (snum < cnum),
    foreign key (cnum) references db.customers(cnum),
    foreign key (snum) references db.sellers(snum),
    constraint unique_cnum_and_snum unique (cnum, snum)
);

create table db.cityorders (
    onum integer references db.orders(onum) primary key,
    amt decimal references db.orders(amt),
    snum integer references db.orders(snum),
    cnum integer references db.customers(cnum),
    city varchar references db.customers(city)
);

alter table db.orders
add column prev integer references db.orders(onum);
update db.orders as a
set prev = (select max(onum)
            from db.orders as b
            where b.cnum = a.cnum and b.onum < a.onum
    );

/*  LAB 12  */

