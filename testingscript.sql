 SET @nextordernum = (select max(ordernumber) + 1 from orders);
 
insert into orders values (@nextordernum,curdate(),curdate(),curdate(), 'Shipped','blah',103);
insert into orderdetails values(@nextordernum, 'S10_1678', 10000000, 100.0, 1);
-- insert into orders values (10426,curdate(),curdate(),curdate(), 'Shipped','blah',103);
-- insert into orderdetails values(10426, 'S10_1678', 10000000, 100.0, 1);
-- delete from orderdetails where ordernumber = 10426;
-- insert into orderdetails values(10426, 'S10_1678', 101, 100.0, 1);
-- insert into orderdetails values(10426, 'S10_1678', 5, 100.0, 1);
-- delete from orderdetails where ordernumber = 10426;
-- delete from orders where ordernumber = 10426;
select * from orders where ordernumber	= @nextordernum;