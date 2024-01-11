-- To-Dos 1

DROP TRIGGER IF EXISTS update_stock;
delimiter $$
CREATE TRIGGER update_stock 
AFTER INSERT ON orderdetails 
   FOR EACH ROW 
      BEGIN  
      DECLARE curqty INT;   
      DECLARE newStatus VARCHAR(15);
      SET newStatus = 'In Process';
      

      -- retrieve current QOH into a variable
      SET curqty = (SELECT quantityInStock       
				    FROM products
                    WHERE productCode = NEW.productCode);
                    
   -- if the qty ordered is too much
   -- yell at user.  
   IF curqty - NEW.quantityordered < 0 THEN

	   SET newStatus = 'Rejected';

   ELSE -- not too much ordered so decrement product QOH by qty ordered
	   
       UPDATE products 
	   SET
			quantityinstock = quantityinstock - new.quantityordered
	   WHERE productcode = NEW.productcode;

   END IF; 
   
   UPDATE orders SET `status` = newStatus WHERE ordernumber = NEW.ordernumber;
   
 END$$
 
 DELIMITER ;
 
SET @nextordernum = (select max(ordernumber) + 1 from orders);
 
insert into orders values (@nextordernum,curdate(),curdate(),curdate(), 'Shipped','reject this',103);
insert into orderdetails values(@nextordernum, 'S10_1678', 1000000, 100.0, 1);

select * from orders where ordernumber	= @nextordernum;
select * from products where productcode = 'S10_1678';
-- select * from orderdetails where ordernumber = @nextordernum;

-- To-Dos - 2 (NOT SURE WHAT TO DO WITH THIS ONE)

DROP TRIGGER IF EXISTS update_stock;
delimiter $$
CREATE TRIGGER update_stock 
AFTER INSERT ON orderdetails 
   FOR EACH ROW 
      BEGIN  
      DECLARE curqty INT;   
      DECLARE newStatus VARCHAR(15);
      SET newStatus = 'In Process';
      

      -- retrieve current QOH into a variable
      SET curqty = (SELECT quantityInStock       
				    FROM products
                    WHERE productCode = NEW.productCode);
                    
   -- if the qty ordered is too much
   -- yell at user.  
   IF curqty - NEW.quantityordered < 0 OR NEW.quantityorder > 100 THEN

	   SET newStatus = 'Rejected';

   ELSE -- not too much ordered so decrement product QOH by qty ordered
	   
       UPDATE products 
	   SET
			quantityinstock = quantityinstock - new.quantityordered
	   WHERE productcode = NEW.productcode;

   END IF; 
   
   UPDATE orders SET `status` = newStatus WHERE ordernumber = NEW.ordernumber;
   
 END$$
 
 DELIMITER ;
 
-- some testing commands
insert into orders values (@nextordernum,curdate(),curdate(),curdate(), 'Shipped','reject this',103);
insert into orderdetails values(@nextordernum, 'S10_1678', 1000000, 100.0, 1);

select * from orders where ordernumber	= @nextordernum;
select * from products where productcode = 'S10_1678';
-- select * from orderdetails where ordernumber = @nextordernum;


-- To-Dos - 3
-- 1. Create a trigger named "log_changes" to automatically log any changes made to the "orders" table into a separate log table.
-- 2. Delete the "log_changes" trigger when it is no longer needed.
-- 3. Observe the behavior of the database after the trigger is deleted and confirm that the logging action is no longer triggered.

-- drop table orderslog;
-- create table orderslog as
-- select * from orders;

-- alter table to  have distinct rows
-- alter table orderslog
-- add column changeID INT primary key auto_increment;
-- alter table orderslog
-- add foreign key (ordernumber) references orders(ordernumber);
-- delete from orderslog;
-- added timestamp column changedTime with GUI

-- Table
CREATE TABLE `orderslog` (
  `changeID` int NOT NULL AUTO_INCREMENT,
  `orderNumber` int NOT NULL,
  `orderDate` date NOT NULL,
  `requiredDate` date NOT NULL,
  `shippedDate` date DEFAULT NULL,
  `status` varchar(15) NOT NULL,
  `comments` text,
  `customerNumber` int NOT NULL,
  `changeTime` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`changeID`)
) ;

-- To-do referential integrity, though is it really needed?


DELIMITER $$
CREATE TRIGGER `log_changes` 
AFTER UPDATE ON `orders` 

FOR EACH ROW BEGIN  
      
      INSERT INTO orderslog (orderNumber, 
                            orderDate,
                            requiredDate,
                            shippedDate,
                            `status`,
                            comments,
                            customerNumber)
      SELECT ordernumber, 
             orderdate, 
             requireddate, 
             shippeddate, 
             `status`, 
             comments, 
             customerNumber
      FROM orders
      WHERE orderNumber = NEW.orderNumber;
     
      END$$
      
DELIMITER ;

DROP TRIGGER `log_changes`;

-- some more testing
SET @nextordernum = (select max(ordernumber) + 1 from orders);
 
insert into orders values (@nextordernum,curdate(),curdate(),curdate(), 'Shipped','reject this',103);
insert into orderdetails values(@nextordernum, 'S10_1678', 1000000, 100.0, 1);

select * from orders where ordernumber	= @nextordernum;
select * from products where productcode = 'S10_1678';
-- select * from orderdetails where ordernumber = @nextordernum;
