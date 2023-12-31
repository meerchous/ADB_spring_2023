USE SHOPDB1;

SELECT * FROM CUSTOMER;
SELECT * FROM BUYER_STOCK;
SELECT * FROM BUYER;
SELECT * FROM INVOICE;
SELECT * FROM INVOICE_ITEM;
SELECT * FROM ORDER_DETAIL;
SELECT * FROM ORDERS;
SELECT * FROM STOCK;


ALTER TABLE STOCK ADD MAX_QTY INT
UPDATE STOCK
SET MAX_QTY = (CASE 
					WHEN s_price > 3000 THEN 10
					WHEN s_price > 1200 THEN 70
					ELSE 100 END)


--1
CREATE PROCEDURE NEED_TO_PURCHASE
AS
BEGIN
DECLARE @S VARCHAR(5000) = (SELECT STRING_AGG(TRIM(s_name), '; ')  FROM STOCK WHERE s_qty < 10)
	SELECT * FROM STOCK WHERE s_qty < 10
	PRINT 'Need to purchase ' + @S
	INSERT INTO ORDERS (O_DATE, TOTAL) VALUES (GETDATE(), (SELECT SUM((S.MAX_QTY - S.S_QTY) * BS.B_S_PRICE) FROM STOCK S
																	JOIN BUYER_STOCK BS ON S.S_NAME = BS.S_NAME 
																	WHERE S_QTY < 10))

	INSERT INTO ORDER_DETAIL (O_ID, S_NAME, QTY)
	SELECT (SELECT TOP 1 O_ID FROM ORDERS ORDER BY O_ID DESC), S_NAME, MAX_QTY - S_QTY 
	FROM STOCK WHERE S_QTY < 10
END

EXEC NEED_TO_PURCHASE

ALTER TABLE ORDER_DETAIL
DROP CONSTRAINT CK__ORDER_DETAI__QTY__403A8C7D;

DELETE FROM ORDERS WHERE O_ID=18;

DROP PROCEDURE NEED_TO_PURCHASE
SELECT * FROM ORDERS;

UPDATE ORDERS
SET O_DATE = '2023-04-01'
WHERE O_ID = 19

CREATE TRIGGER END_OF_PURCHASE
ON ORDERS
AFTER UPDATE
AS
BEGIN
	IF (SELECT DATEDIFF(day, GETDATE(), (SELECT O_DATE FROM ORDERS WHERE O_ID = (SELECT TOP 1 O_ID FROM ORDERS ORDER BY O_ID DESC)))) = -20
	UPDATE STOCK
	SET S_QTY = MAX_QTY
	WHERE S_QTY < 10
END

SELECT * FROM STOCK;

DROP TRIGGER END_OF_PURCHASE

SELECT * FROM BUYER;
SELECT * FROM STOCK;

--2
CREATE TABLE SALE(
CATEGORY VARCHAR(50) PRIMARY KEY,
ACTION_DATE DATE,
PRCNT INT
)

INSERT INTO SALE (CATEGORY, PRCNT) VALUES ('Phone', 30), ('Washing machine', 25), ('TV', 10), ('Laptop', 20), ('Appliances', 35)

ALTER TABLE STOCK
ADD FOREIGN KEY (S_CATEGORY) REFERENCES SALE(CATEGORY);

SELECT * FROM SALE;
DROP TABLE SALE;

UPDATE SALE 
SET ACTION_DATE = NULL
WHERE CATEGORY = 'TV'

ALTER TABLE STOCK
DROP COLUMN DISCOUNT_PRICE 
select * from STOCK;

ALTER TABLE STOCK
ADD DISCOUNT_PRICE INT;

CREATE PROCEDURE UPDATE_THE_PRICE_WITH_DISCOUNTS
AS
BEGIN
	DECLARE @MONTHLY_CATEGORY VARCHAR(50) = (SELECT TOP 1 CATEGORY FROM SALE ORDER BY NEWID())
	DECLARE @CURRENT_DATE DATE = GETDATE()


	IF DATEPART(DAY, @CURRENT_DATE) = 3
	BEGIN
		UPDATE STOCK
		SET DISCOUNT_PRICE = NULL

		UPDATE STOCK
		SET DISCOUNT_PRICE =
		S_PRICE * CAST(100 -(SELECT PRCNT FROM SALE WHERE CATEGORY = @MONTHLY_CATEGORY) AS FLOAT)/CAST(100 AS FLOAT) 
		WHERE S_CATEGORY = @MONTHLY_CATEGORY
	END
END;

EXEC UPDATE_THE_PRICE_WITH_DISCOUNTS

DROP PROCEDURE UPDATE_THE_PRICE_WITH_DISCOUNTS

SELECT * FROM SALE;
SELECT * FROM STOCK;

CREATE TRIGGER MONTHLY_DISCOUNT
ON STOCK
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	EXEC UPDATE_THE_PRICE_WITH_DISCOUNTS
END

SELECT * FROM STOCK;

DROP TRIGGER MONTHLY_DISCOUNT

UPDATE STOCK
SET S_QTY = 99
WHERE S_ID = 1


--3
CREATE TABLE BONUS_CARD(
CARD_NUMBER INT PRIMARY KEY,
CUST_ID INT NOT NULL,
BALANCE FLOAT,
CREATION_DATE DATE NOT NULL,
EXPIRATION_DATE DATE NOT NULL,
FOREIGN KEY (CUST_ID) REFERENCES CUSTOMER(CUST_ID)
)

INSERT INTO BONUS_CARD VALUES (100001, 1, 38.7, '2023-01-13', '2024-01-12'),
(100002, 2, 26.8, '2023-01-20', '2024-01-19'), (100003, 3, 21.9, '2023-02-27', '2024-02-26'),
(100004, 4, 19.9, '2023-02-27', '2024-02-26'), (100005, 5, 245, '2023-02-27', '2024-02-26'),
(100006, 6, 2998, '2023-02-03', '2024-02-02'), (100007, 7, 21.9, '2023-01-19', '2024-01-18')

SELECT * FROM BONUS_CARD

SELECT * FROM INVOICE;
SELECT * FROM INVOICE_ITEM;
SELECT * FROM CUSTOMER;

DROP TABLE BONUS_CARD;

CREATE PROCEDURE BONUS_CARD_PROCEDURE
@CUST_ID INT, @PURCHASE_AMOUNT FLOAT
AS 
BEGIN
	DECLARE @CARD_NUMBER INT
    DECLARE @cardBalance FLOAT
    DECLARE @cardCreateDate DATE

    SELECT @CARD_NUMBER = CARD_NUMBER, @cardBalance = BALANCE, @cardCreateDate = CREATION_DATE
    FROM BONUS_CARD
    WHERE CUST_ID = @CUST_ID

	-- IF CUSTOMER DOESNT HAVE BONUS CARD
	IF NOT EXISTS (SELECT CARD_NUMBER FROM BONUS_CARD WHERE CUST_ID = @CUST_ID)
    BEGIN
        INSERT INTO BONUS_CARD (CARD_NUMBER, CUST_ID, BALANCE, CREATION_DATE, EXPIRATION_DATE)
        VALUES ((SELECT TOP 1 CARD_NUMBER FROM BONUS_CARD ORDER BY CARD_NUMBER DESC) + 1, @CUST_ID, 0, GETDATE(), GETDATE() + 365)
        SELECT @CARD_NUMBER = SCOPE_IDENTITY(), @cardBalance = 0, @cardCreateDate = GETDATE()
    END

	--ACCRUE BONUSES FOR THE PURCHASES
	DECLARE @BONUS_AMOUNT FLOAT = @PURCHASE_AMOUNT * 0.01

	UPDATE BONUS_CARD
	SET BALANCE = BALANCE + @BONUS_AMOUNT
	WHERE CARD_NUMBER = @CARD_NUMBER

	-- Check if there are enough bonuses accumulated on the card to buy or exchange for a gift
	IF @cardBalance + @BONUS_AMOUNT >= 5000
	BEGIN
		PRINT 'In your bonus card ' + CAST(@cardBalance + @BONUS_AMOUNT AS VARCHAR(10)) + ' bonuses. You can either pay for the purchase in full with them, or exchange them for a gift.'
	END

	-- If a year has passed since the bonus card was created, we reset the balance
	IF @cardCreateDate < DATEADD(YEAR, -1, GETDATE())
    BEGIN
        UPDATE BONUS_CARD
        SET BALANCE = 0
        WHERE CARD_NUMBER = @CARD_NUMBER
    END
END

SELECT * FROM INVOICE;
SELECT * FROM INVOICE_ITEM;
INSERT INTO INVOICE VALUES ('2023-04-20', 6, '2023-04-22', 1330)
INSERT INTO INVOICE_ITEM VALUES (9, 12, 1)

EXEC BONUS_CARD_PROCEDURE @CUST_ID = 5, @PURCHASE_AMOUNT = 1330

CREATE TRIGGER UPDATE_BONUS_CARD
ON INVOICE
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @CUST_ID INT = (SELECT TOP 1 CUST_ID FROM INVOICE ORDER BY CUST_ID DESC)
	DECLARE @cardBalance FLOAT
	DECLARE @CARD_NUMBER INT

	SELECT @CARD_NUMBER = CARD_NUMBER, @cardBalance = BALANCE
    FROM BONUS_CARD
    WHERE CUST_ID = @CUST_ID

	-- If 10,000 bonuses have accumulated on the card, we notify the buyer of the need to spend them
	IF @cardBalance >= 10000
    BEGIN
        PRINT 'In your bonus card ' + CAST(@cardBalance AS VARCHAR(10)) + ' bonuses. It is necessary to spend them within 3 days, otherwise they will burn.'
		UPDATE BONUS_CARD
		SET EXPIRATION_DATE = DATEADD(day, 3, GETDATE()) 
		WHERE CARD_NUMBER = @CARD_NUMBER
	END
END
	


--4
CREATE TABLE EMPLOYEE(
E_ID INT PRIMARY KEY,
E_NAME VARCHAR(100),
SALARY INT
)

INSERT INTO EMPLOYEE VALUES (1, 'Maral', 500), (2, 'Aruzhan', 500)

ALTER TABLE INVOICE
ADD FOREIGN KEY (E_ID) REFERENCES EMPLOYEE(E_ID)
SELECT * FROM EMPLOYEE;
SELECT * FROM INVOICE;
SELECT * FROM ORDERS;

UPDATE INVOICE
SET E_ID = CASE WHEN DAY(INVOICE_DATE) % 2 = 0 THEN 1 ELSE 2 END

UPDATE INVOICE
SET INVOICE_DATE = '2023-02-27'
WHERE INVOICE_ID = 7

CREATE PROCEDURE CalculateMonthlyProfit
    @month INT,
    @year INT
AS
BEGIN
    DECLARE @startDate DATE = DATEFROMPARTS(@year, @month, 1)
    DECLARE @endDate DATE = DATEADD(DAY, -1, DATEADD(MONTH, 1, @startDate))

    -- Calculation of monthly income
    DECLARE @income DECIMAL(10, 2) = (
        SELECT SUM(SUBTOTAL)
        FROM INVOICE
        WHERE PAID_DATE BETWEEN @startDate AND @endDate
    )

    -- Calculation of expenses for the month
    DECLARE @expenses DECIMAL(10, 2) = (
        SELECT SUM(TOTAL)
        FROM ORDERS
        WHERE O_DATE BETWEEN @startDate AND @endDate
    )

    -- Calculation of payroll costs for store employees
    DECLARE @salaryExpenses DECIMAL(10, 2) = (
        SELECT SUM(SALARY)
        FROM EMPLOYEE
    )

    -- Calculation of net profit
    DECLARE @netProfit DECIMAL(10, 2) = @income - @expenses - @salaryExpenses 

    -- Calculation of the share of profit that remains in the turnover of the store
    DECLARE @storeProfit DECIMAL(10, 2) = @netProfit * 0.5

    -- Calculation of the share of profit that goes to the director's account
    DECLARE @directorProfit DECIMAL(10, 2) = @netProfit - @storeProfit

    -- Output of results
    SELECT @income AS Income, @expenses AS Expenses, @salaryExpenses AS SalaryExpenses,
        @netProfit AS NetProfit, @storeProfit AS StoreProfit, @directorProfit AS DirectorProfit
END

EXEC CalculateMonthlyProfit @month = 2, @year = 2023

--5
SELECT * FROM CUSTOMER;
SELECT * FROM INVOICE;
SELECT * FROM INVOICE_ITEM;

Alter table INVOICE
add STATUSS varchar(100)

CREATE TABLE CALLS(
CALL_ID INT PRIMARY KEY,
I_ID INT,
CALL_TIME DATETIME,
CONSTRAINT FK_CALLS_INVOICE FOREIGN KEY (I_ID) REFERENCES INVOICE(INVOICE_ID)
)
SELECT * FROM INVOICE;
SELECT * FROM CALLS;
INSERT INTO CALLS VALUES (1, 8, '2023-03-04 12:18:12')

UPDATE INVOICE
SET STATUSS = 'Order completed'
WHERE INVOICE_ID = 8

CREATE PROCEDURE HomeDelivery
    @CustomerID NVARCHAR(50),
    @Subtotal INT,
    @Status NVARCHAR(50) = 'In process'
AS
BEGIN
    SET NOCOUNT ON;
	
    -- Insert a new order into the table INVOICE
    INSERT INTO INVOICE (INVOICE_DATE, CUST_ID, PAID_DATE, SUBTOTAL, E_ID, STATUSS)
    VALUES (GETDATE(), @CustomerID, GETDATE(), @Subtotal, IIF(DAY(GETDATE())%2=0, 1, 2), @Status);

    -- Getting the ID of the new order
    DECLARE @InvoiceId INT = SCOPE_IDENTITY();

    -- Fix the call in the Calls table
	DECLARE @CallID INT = (SELECT TOP 1 CALL_ID FROM CALLS ORDER BY CALL_ID DESC)
    INSERT INTO CALLS (CALL_ID, I_ID, CALL_TIME)
    VALUES (@CallID + 1, @InvoiceId, GETDATE());

    -- Update the order status for "Product Search"
    UPDATE INVOICE SET STATUSS = 'Product Search' WHERE INVOICE_ID = @InvoiceId;
	PRINT 'Product Search'

    -- Update the order status to "Order Collection"
    WAITFOR DELAY '00:00:05'; -- Simulation of the order collection time
    UPDATE INVOICE SET STATUSS = 'Order Collection' WHERE INVOICE_ID = @InvoiceId;
	PRINT 'Order Collection'

    -- Update the order status to "Sending an order"
    WAITFOR DELAY '00:00:10'; -- Simulation of the order collection time
    UPDATE INVOICE SET STATUSS = 'Sending an order' WHERE INVOICE_ID = @InvoiceId;
	PRINT 'Sending an order'

    -- Update the order status to "Order completed"
    WAITFOR DELAY '00:00:15'; -- Simulation of the order collection time
    UPDATE INVOICE SET STATUSS = 'Order completed' WHERE INVOICE_ID = @InvoiceId;
	PRINT 'Order completed'
END

EXEC HomeDelivery @CustomerID = 1, @Subtotal = 2600

SELECT * FROM INVOICE_ITEM;
SELECT * FROM INVOICE;
DROP PROCEDURE HomeDelivery;

INSERT INTO INVOICE_ITEM VALUES (13, 13, 2)


INSERT INTO INVOICE VALUES (GETDATE(), 3, GETDATE(), 2980, 2, NULL)

-- Remove products taken to collect order
CREATE TRIGGER UPDATE_STOCK
ON INVOICE
AFTER UPDATE, INSERT
AS
BEGIN
	UPDATE STOCK
   	SET S_QTY = (SELECT S.S_QTY-I.I_QTY FROM INVOICE_ITEM I JOIN STOCK S ON S.S_ID=I.S_ID
   	JOIN INVOICE IE ON
   	IE.INVOICE_ID=I.INVOICE_ID
   	WHERE IE.STATUSS = 'Order collection')
END

SELECT * FROM STOCK;


--6 
--CREATING STAGE-- PROCEDURE
CREATE DATABASE SHOP;

USE SHOP;

CREATE PROCEDURE BUILD_DATABASE_SHOP
AS 
BEGIN

CREATE TABLE BUYER(
B_ID INT IDENTITY(100,1) PRIMARY KEY,
B_NAME VARCHAR(50) NOT NULL,
B_ADDRESS VARCHAR(60) NOT NULL,
B_COUNTRY VARCHAR(30) NOT NULL,
DELIVERY_TIME INT NOT NULL,
MIN_QTY INT NOT NULL);

CREATE TABLE BUYER_STOCK(
S_NAME VARCHAR(100) PRIMARY KEY,
B_ID INT FOREIGN KEY REFERENCES BUYER(B_ID) ON DELETE CASCADE,
B_S_PRICE INT NOT NULL);

CREATE TABLE ORDERS(
O_ID INT IDENTITY(1,1) PRIMARY KEY,
O_DATE DATE NOT NULL,
TOTAL INT NOT NULL);

CREATE TABLE ORDER_DETAIL(
O_ID INT FOREIGN KEY REFERENCES ORDERS(O_ID) ON DELETE CASCADE,
S_NAME VARCHAR(100) FOREIGN KEY REFERENCES BUYER_STOCK(S_NAME),
QTY INT NOT NULL, 
CHECK (QTY >= 10),
CONSTRAINT COMP_NAME_1 PRIMARY KEY (O_ID,S_NAME));

CREATE TABLE STOCK(
S_ID INT PRIMARY KEY,
S_NAME VARCHAR(100) FOREIGN KEY REFERENCES BUYER_STOCK(S_NAME) ON DELETE CASCADE, 
S_CATEGORY VARCHAR(50) NOT NULL,
S_QTY INT,
S_PRICE INT NOT NULL);

CREATE TABLE CUSTOMER(
CUST_ID INT IDENTITY(1,1) PRIMARY KEY,
CUST_NAME VARCHAR(60) NOT NULL,
CUST_ADDRESS VARCHAR(50) NOT NULL,
CUST_PHONE VARCHAR(11) NOT NULL);

CREATE TABLE INVOICE(
INVOICE_ID INT IDENTITY(1,1) PRIMARY KEY ,
INVOICE_DATE DATE NOT NULL,
CUST_ID INT FOREIGN KEY REFERENCES CUSTOMER(CUST_ID) ON DELETE CASCADE,
PAID_DATE DATE,
SUBTOTAL INT NOT NULL);

CREATE TABLE INVOICE_ITEM(
INVOICE_ID INT FOREIGN KEY REFERENCES INVOICE(INVOICE_ID) ON DELETE CASCADE,
S_ID INT FOREIGN KEY REFERENCES STOCK(S_ID),
I_QTY INT NOT NULL,
CONSTRAINT COMP_NAME_2 PRIMARY KEY (INVOICE_ID,S_ID));

--INSERT--
INSERT INTO BUYER values
('Apple Inc.', 'California, San-Francisco, Cupertino ', 'USA', 20, 10),
('Samsung Group', 'Seoul, Giheung', 'South Korea', 15, 10),
('LG Electronics Inc.', 'Lg Twin Tower 128','South Korea', 15, 10),
('Acer Inc.', 'Xizhi, New Taipei', 'Taiwan', 30, 10),
('Dyson Limited', 'St James Power Station, Harbourfront', 'Singapore', 25, 10);

INSERT INTO BUYER_STOCK VALUES
('Iphone 14 Pro, black, 256GB',100,1200),
('Iphone 13, blue, 128GB',100, 950),
('Samsung S22 Ultra, white, 256GB', 101, 1000),
('Samsung S21 Ultra, pink,512GB', 101, 1000),
('LG Washing-machine F2H5990, black, 10kg', 102, 600),
('Samsung Washing-machine WW5300B, white, 11kg',101, 700),
('Samsung TV Neo QLED 4K QN85B, gray, 55"', 101, 1400),
('Apple Macbook Air 13 MGN63, gray, 256GB', 100, 1000),
('Acer Swift 3 SF314-43, silver, 512GB', 103, 970),
('Acer Predator Triton 500 SE, silver, 1024GB', 103, 3500),
('Dyson HD07, Hair Dryer, 1600W', 104, 850),
('Dyson HS05 Airwrap Complete, 1300W', 104, 1120),
('Samsung Galaxy Z Flip 3 New, green, 128GB', 101, 1200);

INSERT INTO ORDERS VALUES
('2023-01-01',314000),
('2023-02-01',24500),
('2023-02-12', 64000),
('2023-02-15', 93200);

INSERT INTO ORDER_DETAIL VALUES
(1, 'Iphone 14 Pro, black, 256GB', 100),
(1, 'Iphone 13, blue, 128GB', 100),
(1, 'Samsung S22 Ultra, white, 256GB', 50),
(1, 'Samsung S21 Ultra, pink,512GB', 50),
(1, 'LG Washing-machine F2H5990, black, 10kg', 20),
(2, 'Samsung Washing-machine WW5300B, white, 11kg', 15),
(2, 'Samsung TV Neo QLED 4K QN85B, gray, 55"', 10),
(3, 'Apple Macbook Air 13 MGN63, gray, 256GB', 30),
(3, 'Dyson HD07, Hair Dryer, 1600W', 40),
(4, 'Acer Predator Triton 500 SE, silver, 1024GB', 10),
(4, 'Acer Swift 3 SF314-43, silver, 512GB', 60);


INSERT INTO STOCK VALUES 
(1,'Iphone 14 Pro, black, 256GB','Phone',100, 1490),
(2,'Iphone 13, blue, 128GB', 'Phone', 100, 1290),
(3,'Samsung S22 Ultra, white, 256GB', 'Phone', 50, 1390),
(4,'Samsung S21 Ultra, pink,512GB', 'Phone', 50, 1190),
(5,'LG Washing-machine F2H5990, black, 10kg','Washing machine', 20, 890),
(6,'Samsung Washing-machine WW5300B, white, 11kg', 'Washing machine', 15, 990),
(7,'Samsung TV Neo QLED 4K QN85B, gray, 55"','TV' , 10, 1990),
(8, 'Apple Macbook Air 13 MGN63, gray, 256GB', 'Laptop', 2, 1170),
(9, 'Acer Swift 3 SF314-43, silver, 512GB', 'Laptop', 9, 1030),
(10, 'Acer Predator Triton 500 SE, silver, 1024GB', 'Laptop', 1, 3700),
(11, 'Dyson HD07, Hair Dryer, 1600W', 'Appliances', 19, 980),
(12, 'Dyson HS05 Airwrap Complete, 1300W', 'Appliances', 17, 1330),
(13, 'Samsung Galaxy Z Flip 3 New, green, 128GB', 'Phone', 4, 1300);

INSERT INTO CUSTOMER VALUES 
('Aizhan Abylkasymova', 'Tole bi 59', '7776543289'),
('Aliya Borsikbaeva', 'Abylai khan 23', '7079843677'),
('Anel Zainoldanova', 'Suleimenova 24', '7053790831'),
('Adilkhan Zhumabekov', 'Aksai 4', '7784371700'),
('Meyirim Syzdykova', 'Samal 2', '7476258840'),
('KBTU Research Group', 'Tastak 3', '77273574251'),
('Azamat Azamatovich', 'Altyn bylak 65', '7783450012');

INSERT INTO INVOICE VALUES
('2023-01-13', 1, '2023-01-13', 2980),
('2023-01-17', 2, '2023-01-20', 2680),
('2023-01-19', 7, NULL, 2190),
('2023-01-20', 1, '2023-01-21', 890),
('2023-02-03', 6, '2023-02-05', 299800),
('2023-02-27', 4, NULL, 1990),
('2023-02-25', 3, NULL, 3310),
('2023-02-27', 5, NULL, 24500);

INSERT INTO INVOICE_ITEM VALUES
(1,1,2),
(2,2,1),
(2,3,1),
(1,4,1),
(6,1,80),
(6,2,80),
(6,3,30),
(6,4,30),
(4,7,1),
(3,12,1),
(3,6,2),
(7,13,1),
(7,5,1),
(8,11,25);

ALTER TABLE STOCK ADD MAX_QTY INT
UPDATE STOCK
SET MAX_QTY = (CASE 
          WHEN s_price > 3000 THEN 10
          WHEN s_price > 1200 THEN 70
          ELSE 100 END)

END
EXECUTE BUILD_DATABASE_SHOP

--TRIGGER
CREATE TRIGGER NUM_CHECKER 
ON CUSTOMER
AFTER INSERT
AS UPDATE CUSTOMER
SET CUST_PHONE = STUFF(CUST_PHONE,1,1,'7')
WHERE CUST_ID = (SELECT CUST_ID FROM INSERTED)

DROP TRIGGER NUM_CHECKER

INSERT INTO CUSTOMER VALUES ('Ivan Ivanovich', 'Pushkin 2', '87057639800')

SELECT * FROM CUSTOMER;