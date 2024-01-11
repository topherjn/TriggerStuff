-- Task 3

-- Cheat at creating the table
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

-- Trigger
CREATE DEFINER=`root`@`localhost` TRIGGER `log_changes` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN  
      
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
     
      END
