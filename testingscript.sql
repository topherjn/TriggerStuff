SET @nextordernum = (select max(ordernumber) + 1 from orders);
 
insert into orders values (@nextordernum,curdate(),curdate(),curdate(), 'Shipped','blah',103);
insert into orderdetails values(@nextordernum, 'S10_1678', 10000000, 100.0, 1);

select * from orders where ordernumber	= @nextordernum;
-- select * from orderdetails where ordernumber = @nextordernum;