DROP TRIGGER IF EXISTS update_stock;
delimiter $$
CREATE TRIGGER update_stock 
AFTER INSERT ON orderdetails 
   FOR EACH ROW 
      BEGIN  
      DECLARE curqty INT;   
      
      UPDATE orders SET `status` = 'Rejected' WHERE ordernumber = NEW.ordernumber;
      
      -- retrieve current QOH into a variable
      SET curqty = (SELECT quantityInStock       
				    FROM products
                    WHERE productCode = NEW.productCode);
                    
   -- if the qty ordered is too much
   -- yell at user.  
   IF curqty - NEW.quantityordered < 0 THEN
       UPDATE orders SET `status` = 'Cancelled' WHERE ordernumber = NEW.ordernumber;
	   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock cannot be negative'; 
   ELSE -- not too much ordered so decrement product QOH by qty ordered
	   UPDATE products 
	   SET
			quantityinstock = quantityinstock - new.quantityordered
	   WHERE productcode = NEW.productcode;
       
       UPDATE orders SET `status` = 'In Progress' WHERE ordernumber = NEW.ordernumber;
   
   END IF; 
   
   
   
 END$$
 
 DELIMITER ;
