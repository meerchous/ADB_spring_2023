use lab11

/* #1 */
CREATE FUNCTION prod_change_price(
@prod_id VARCHAR(10),
@chng_prcnt INT,
@how_to_chng VARCHAR(1))
RETURNS FLOAT
AS
BEGIN
DECLARE @changings FLOAT = (CASE
								WHEN @how_to_chng = '+' THEN CAST(100+@chng_prcnt AS FLOAT)/CAST(100 AS FLOAT) 
								WHEN @how_to_chng = '-' THEN CAST(100-@chng_prcnt AS FLOAT)/CAST(100 AS FLOAT)
							END)
DECLARE @res FLOAT = (SELECT prod_price* @changings FROM Products WHERE prod_id = @prod_id)
RETURN ROUND(@res,2)		
END

SELECT prod_price FROM Products WHERE prod_id='BNBG01'
SELECT dbo.prod_change_price('BNBG01',10,'+')

DROP FUNCTION prod_change_price

/* #2 */

CREATE FUNCTION GETSTATE(
@vend_id VARCHAR(10))
RETURNS VARCHAR(10)
AS BEGIN
DECLARE @res VARCHAR(10) = (SELECT IIF( vend_state IS NULL, 'Unknown', vend_state) FROM Vendors WHERE vend_id = @vend_id)
RETURN @res
END

PRINT DBO.GETSTATE('FNG01')

DROP FUNCTION GETSTATE()


/* #3 */
CREATE FUNCTION COUNTRY(
@country VARCHAR(10))
RETURNS TABLE
AS
RETURN
SELECT
	COUNT(vend_id) AS vend_n,
	COUNT(cust_id) AS cust_n,
	vend_country AS country
FROM
	Vendors AS V
	FULL OUTER JOIN 
	Customers AS C 
	ON V.vend_country = C.cust_country 
GROUP BY 
	vend_country 
HAVING 
	vend_country = @country

SELECT*FROM DBO.COUNTRY('England')
/* #4 */
CREATE FUNCTION EMAIL_VENDERS(
@name VARCHAR(100))
RETURNS VARCHAR(100)
AS 
BEGIN 
	SET @name = LOWER(CONCAT( LEFT(@name,CHARINDEX(' ',@name)-1),'.', SUBSTRING(@name,(CHARINDEX(' ',@name))+1,1), '@gmail.com') ) 
	RETURN @name
END

SELECT vend_name, dbo.email_venders(vend_name) AS vend_mail FROM Vendors

DROP FUNCTION EMAIL_VENDERS

/* #5 */
CREATE FUNCTION GetMonth(@input VARCHAR(15))
RETURNS INT
AS 
BEGIN
IF @input = 'Январь'
	SET @input = 1
ELSE IF @input = 'Февраль'
	SET @input = 2 
ELSE IF @input = 'Март'
	SET @input = 3 
ELSE IF @input = 'Апрель'
	SET @input = 4 
ELSE IF @input = 'Май'
	SET @input = 5 
ELSE IF @input = 'Июнь'
	SET @input = 6 
ELSE IF @input = 'Июль'
	SET @input = 7
ELSE IF @input = 'Август'
	SET @input = 8 
ELSE IF @input = 'Сентябрь'
	SET @input = 9
ELSE IF @input = 'Октябрь'
	SET @input = 10 
ELSE IF @input = 'Ноябрь'
	SET @input = 11 
ELSE IF @input = 'Декабрь'
	SET @input = 12 
ElSE RETURN(' Input nepravilnyi') 

RETURN (SELECT COUNT(order_num) FROM Orders 
		Where MONTH(order_date) = @input)
END

SELECT DBO.GetMonth('Май')

DROP FUNCTION GetMonth
/* #6*/
CREATE FUNCTION daysAfterOrder(@order_id INT)
RETURNS FLOAT
AS 
BEGIN
RETURN
(SELECT
	DATEDIFF(day,order_date,getdate()) AS column1
FROM 
	Orders
WHERE 
	order_num = @order_id)
END

SELECT DBO.daysAfterOrder(20005) AS days_after_order

DROP FUNCTION daysAfterOrder
/* #7 */
CREATE FUNCTION total_price()
RETURNS TABLE 
AS 
RETURN 
	SELECT
		*, CONCAT(ROUND(quantity*item_price,2),'$') as total_price
	FROM 
		OrderItems


SELECT*FROM DBO.total_price()

/* #8 */

CREATE FUNCTION get_address_number(@id INT)
RETURNS INT
AS 
BEGIN
RETURN
(SELECT
	CONVERT(INT,STUFF(cust_address,PATINDEX('%[^012345678]%',cust_address),len(cust_address),'')) AS address_num
FROM
	Customers
WHERE 
	cust_id = @id)
END

select *from customers where cust_id = 1000000001
select dbo.get_address_number(1000000001) as address_num

/* #9 */
CREATE FUNCTION FUNC_1(@str VARCHAR(100))
RETURNS VARCHAR(3)
AS 
BEGIN
DECLARE @len INT = LEN(@str)
DECLARE @str1 varchar(100)
DECLARE @str2 varchar(100)
IF @len%2 = 0
 BEGIN
  SET @str1 = SUBSTRING(@str,1,@len/2)
  SET @str2 = REVERSE(SUBSTRING(@str,@len/2+1,@len+1))
 END
ELSE	
 BEGIN
	SET @str1 = SUBSTRING(@str,1,(@len)/2)
    SET @str2 = REVERSE(SUBSTRING(@str,(@len+1)/2+1,@len+1))
 END
RETURN (CASE 
WHEN @str1=@str2 THEN 'YES'
ELSE 'NO'
END)

END

PRINT DBO.FUNC_1('ASD')
PRINT DBO.FUNC_1('ASA')

drop function func_1

/* #10 */