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

-- To-Dos - 2 (NOT SURE WHAT TO DO WITH THIS ONE)
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

