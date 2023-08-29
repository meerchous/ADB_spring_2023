use lab11

/* #1 */
CREATE TRIGGER CHANGES ON VENDORS
AFTER DELETE, INSERT,UPDATE
AS 
BEGIN  
	print CONCAT('changes were made ',GETDATE())
END
INSERT INTO VENDORS
	VALUES('SIL101', 'Ana Soklič', '158 HEY CHILD', 'Ljubljana', NULL, 95159, 'SI')

/* #2 */
CREATE TRIGGER REMOVE ON ORDERITEMS
AFTER DELETE  
AS
BEGIN
	DECLARE @PROD_ID VARCHAR(10), @QTY INT
	SELECT @PROD_ID = DELETED.PROD_ID, @QTY = DELETED.QUANTITY FROM DELETED 
	UPDATE Products
	SET amount = AMOUNT + @QTY
	WHERE PROD_ID = @PROD_ID
END

DROP TRIGGER REMOVE

SELECT * FROM OrderItems WHERE order_num=20009 AND prod_id='BNBG03'
SELECT * FROM Products WHERE prod_id='BNBG03'
DELETE FROM OrderItems WHERE order_num=20009 AND prod_id='BNBG03'
SELECT * FROM OrderItems WHERE order_num=20009 AND prod_id='BNBG03'
SELECT * FROM Products WHERE prod_id='BNBG03'

/* #3 */
CREATE TRIGGER ID_GEN ON CUSTOMERS
AFTER INSERT 
AS 
BEGIN
	DECLARE @ID INT = (SELECT TOP 1 CUST_ID+1 FROM CUSTOMERS ORDER BY CUST_ID DESC) 
	UPDATE CUSTOMERS
	SET CUST_ID = @ID
	WHERE CUST_ID = (SELECT CUST_ID FROM INSERTED)
END


INSERT INTO CUSTOMERS VALUES 
('1', 'Some Name', 'Tole bi 50', 'Almaty', null, '050000', 'Kazakhstan', 'Alua Smagulova', null)
select*from customers

/* #4 */
CREATE TRIGGER DEL ON VENDORS
INSTEAD OF DELETE 
AS 
BEGIN
	DECLARE @vend VARCHAR(20) = (SELECT vend_id from deleted)
	
	DELETE from OrderItems
	WHERE prod_id in (select prod_id from vendors V join Products P on V.vend_id= P.vend_id
	where P.vend_id = @vend)
	
	DELETE from products 
	WHERE vend_id = @vend

	DELETE FROM VENDORS 
	WHERE vend_id = @vend
END

DROP TRIGGER del

INSERT INTO VENDORS VALUES('AAA123','Name','address','Atyrau',NULL,'06000','KZ')
INSERT INTO PRODUCTS VALUES ('AAA1', 'AAA123' , '1 prod', 100, 10.6, '')
INSERT INTO PRODUCTS VALUES ('AAA2', 'AAA123' , '2 prod', 52, 5.5, '')
INSERT INTO OrderItems(order_num, prod_id, quantity, item_price, order_item) VALUES (20010, 'AAA1', 20, 12.72, 1)

SELECT*FROM OrderItems WHERE prod_id='AAA1'
SELECT*FROM Products WHERE vend_id='AAA123'
SELECT*FROM Vendors WHERE vend_id='AAA123'
DELETE FROM Vendors WHERE vend_id='AAA123'
SELECT*FROM OrderItems WHERE prod_id='AAA1'
SELECT*FROM Products WHERE vend_id='AAA123'
SELECT*FROM Vendors WHERE vend_id='AAA123'

INSERT INTO ORDERS VALUES (20010, '2023-05-01',1000000001)
SELECT * FROM ORDERS


/* #5 */
CREATE TRIGGER price ON Products 
AFTER INSERT
AS 
BEGIN
	DECLARE @id varchar(20) = (SELECT prod_id FROM INSERTED)
	DECLARE @name varchar(100) = (SELECT trim(prod_name) FROM INSERTED)
	
	UPDATE Products
	SET prod_price = prod_price*1.2
	WHERE prod_id = @id
	
	PRINT CONCAT(@name,' added!')
END

INSERT INTO Products VALUES 
('BR04', 'BRS01', '20 inch teddy bear', 50, 12, '20 inch teddy bear, comes with cap and jacket')
SELECT * FROM Products


drop trigger price
delete from products 
where prod_id= 'BR04'

/* #6 */
CREATE TRIGGER DATE ON ORDERS 
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO ORDERS(order_num,order_date,cust_id)
	SELECT order_num,GETDATE(),cust_id FROM INSERTED
END

INSERT INTO Orders (order_num, cust_id) VALUES(20011, '1000000006')
SELECT*FROM Orders

DROP TRIGGER DATE
