-- To-Dos 1
-- 1. Create a trigger named "update_stock" that fires before an update on the 
--    "products" table to ensure stock levels are maintained accurately.
DELIMITER $$
CREATE TRIGGER update_stock
BEFORE UPDATE ON products
	
-- 2. Implement the trigger action statements to verify if the new stock level 
--    is greater than or equal to zero.

FOR EACH ROW
BEGIN
	IF NEW.quantityInStock < 0 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Stock cannot be negative';
	END IF;
END$$

DELIMITER ;

-- 3. Test the trigger by updating the stock level of a product and observe the
--    trigger's effect.
update products set quantityinstock = -1;

-- The right way
DELETE FROM orderdetails 
WHERE orderNumber = 10426;
DELETE FROM ORDERS WHERE orderNumber = 10426;


drop trigger if exists update_stock;
delimiter $$
CREATE TRIGGER update_stock 
AFTER INSERT ON orderdetails 
   FOR EACH ROW 
      BEGIN  
      DECLARE curqty INT;     
      SET curqty = (SELECT quantityInStock       
				    FROM orderdetails od                    
					INNER JOIN products p               
					ON od.productCode = p.productCode                
					WHERE ordernumber = NEW.ordernumber            
					AND p.productCode = NEW.productcode); 
                    
   IF curqty - NEW.quantityordered < 0 THEN   
	   SIGNAL SQLSTATE '45000' 
	   SET MESSAGE_TEXT = 'Stock cannot be negative'; 
   ELSE
	   UPDATE products 
   SET
		quantityinstock = quantityinstock - new.quantityordered
   WHERE productcode = NEW.productcode;
 END IF; 

 END$$
 
 DELIMITER ;

-- To-Dos - 2
-- 1. Modify the "update_stock" trigger to also enforce a maximum stock level of 100 for products.
DELIMITER $$
DROP TRIGGER update_stock;
CREATE TRIGGER update_stock
BEFORE UPDATE ON products
	
-- 2. Implement the trigger action statements to verify if the new stock level 
--    is greater than or equal to zero.

FOR EACH ROW
BEGIN
	IF NEW.quantityInStock < 0 OR NEW.quantityInStock > 100 THEN
		SIGNAL SQLSTATE '45000'
        -- 2. Update the trigger action statements to validate if the new stock level exceeds the maximum allowed.
			SET MESSAGE_TEXT = 'Stock quantity must remain between 1 and 100';
	END IF;
END$$

DELIMITER ;

-- 3. Test the modified trigger by attempting to update the stock level to a value greater than 100.
update products set quantityinstock = -1;
update products set quantityinstock = 101;

-- To-Dos - 3
-- 1. Create a trigger named "log_changes" to automatically log any changes made to the "orders" table into a separate log table.

-- 2. Delete the "log_changes" trigger when it is no longer needed.
-- 3. Observe the behavior of the database after the trigger is deleted and confirm that the logging action is no longer triggered.
