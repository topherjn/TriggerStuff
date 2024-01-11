-- Task 3

-- Cheat at creating the table
-- drop table orderslog;
create table orderslog as
select * from orders;

-- alter table to  have distinct rows
alter table orderslog
add column changeID INT primary key auto_increment;
alter table orderslog
add foreign key (ordernumber) references orders(ordernumber);
delete from orderslog;

-- Trigger

