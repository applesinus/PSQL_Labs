create schema db

create table db.sellers (
    snum integer primary key,
    sname varchar not null,
    city varchar not null,
    comm decimal not null
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