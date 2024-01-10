DROP TRIGGER IF EXISTS update_stock;
delimiter $$
CREATE TRIGGER update_stock 
AFTER INSERT ON orderdetails 
   FOR EACH ROW 
      BEGIN  
      DECLARE curqty INT;   
      DECLARE newStatus VARCHAR(15);
      
      SET curqty = (SELECT quantityInStock       
				    FROM orderdetails od                    
					INNER JOIN products p               
					ON od.productCode = p.productCode                
					WHERE ordernumber = NEW.ordernumber            
					AND p.productCode = NEW.productcode); 
                    
   IF curqty - NEW.quantityordered < 0 THEN   
	   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock cannot be negative'; 
   ELSE
	   UPDATE products 
		SET
			quantityinstock = quantityinstock - new.quantityordered
		WHERE productcode = NEW.productcode;
   
   END IF; 
   
 END$$
 
 DELIMITER ;


insert into orders values (10427,curdate(),curdate(),curdate(), 'Shipped','blah',103);
insert into orderdetails values(10427, 'S10_1678', 10000000, 100.0, 1);
-- insert into orders values (10426,curdate(),curdate(),curdate(), 'Shipped','blah',103);
-- insert into orderdetails values(10426, 'S10_1678', 10000000, 100.0, 1);
-- delete from orderdetails where ordernumber = 10426;
-- insert into orderdetails values(10426, 'S10_1678', 101, 100.0, 1);
-- insert into orderdetails values(10426, 'S10_1678', 5, 100.0, 1);
-- delete from orderdetails where ordernumber = 10426;
-- delete from orders where ordernumber = 10426;
