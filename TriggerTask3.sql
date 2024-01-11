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

-- Trigger
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
     
      END
