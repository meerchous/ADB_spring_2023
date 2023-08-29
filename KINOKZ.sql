CREATE DATABASE KINOKZ3;
DROP DATABASE KINO
USE KINOKZ3;
USE MASTER


----- DATABASE BUILDING PROCEDURE -----

CREATE PROCEDURE BUILDER
AS
BEGIN

CREATE TABLE AFISHA(
A_CODE VARCHAR(10) PRIMARY KEY,
START_DATE DATE NOT NULL,
END_DATE DATE NOT NULL)

CREATE TABLE AFISHA_DETAIL(
AD_CODE INT IDENTITY(100,1) PRIMARY KEY,
A_CODE VARCHAR(10) FOREIGN KEY REFERENCES AFISHA(A_CODE) ON DELETE CASCADE,
NAME VARCHAR(100) NOT NULL,
CAST VARCHAR(MAX),
DIRECTOR VARCHAR(35),
PRODUCTION VARCHAR(35),
RESTRICTION VARCHAR(10),
MINUTES INT NULL,
REV_KINOKZ DEC(3,2),
GENRE VARCHAR(MAX),
DESCRIPTION VARCHAR(MAX),
EVENT_CATEGORY VARCHAR(30),
LANGUAGE VARCHAR(15))

CREATE TABLE AUDITORIUM(
AUD_ID VARCHAR(10) PRIMARY KEY,
NAME VARCHAR(50) NOT NULL,
ADDRESS VARCHAR(MAX) NOT NULL,
CAPACITY INT NOT NULL,
MAX_ROW INT NOT NULL)

CREATE TABLE SCHEDULED_AFISHA(
SA_ID INT IDENTITY(1,1) PRIMARY KEY,
A_CODE VARCHAR(10) FOREIGN KEY REFERENCES AFISHA(A_CODE) ON DELETE CASCADE,
AUD_ID VARCHAR(10) FOREIGN KEY REFERENCES AUDITORIUM(AUD_ID),
SEANS_TIME DATETIME,
PRICE_ADULT INT,
PRICE_STUDENT INT,
PRICE_KID INT,
PRICE_VIP INT)

CREATE TABLE CUSTOMER(
CUST_ID VARCHAR(50) PRIMARY KEY,
FULLNAME VARCHAR(100))

CREATE TABLE RESERVATION(
RES_ID INT IDENTITY(1,1) PRIMARY KEY,
CUST_ID VARCHAR(50) FOREIGN KEY REFERENCES CUSTOMER(CUST_ID),
RES_DATE DATETIME,
TOTAL INT,
PAID VARCHAR(20)
)

CREATE TABLE RESER_DET(
RES_ID INT FOREIGN KEY REFERENCES RESERVATION(RES_ID) ON DELETE CASCADE,
SA_ID INT FOREIGN KEY REFERENCES SCHEDULED_AFISHA(SA_ID),
SEAT_NUM VARCHAR(MAX),
RATING FLOAT,
REVIEW VARCHAR(MAX),
CONSTRAINT MY_COMP PRIMARY KEY (RES_ID,SA_ID))

--INSERTS

INSERT INTO CUSTOMER VALUES
('+7777345343', 'Bauyrzhanova Dinara'),
('87051523434','Saduakasov Ermek'),
('87055675677','Serikova Asel'),
('87085669923', 'Esimova Aiya'),
('87773410045', 'Asad Aslan'),
('87054329632', 'Alim Gaziz'),
('87018849032', 'Abyl Ayaulym'),
('87753939048', 'Sabyr Serik'),
('87783456543', 'Maksat Sabina'),
('87011234567', 'Osmankhan Nazira'),
('87472345099', 'Elubai Dina'),
('87079872345', 'Kim Kamila')
('87058746744', 'Ivanov Ivan')

INSERT INTO AUDITORIUM VALUES 
('MG1', 'Mega Center Alma-Ata', 'Улица Розыбакиева, 247a', 150, 10), 
('MG2', 'Mega Center Alma-Ata', 'Улица Розыбакиева, 247a', 100, 10),
('FR1', 'FORUM', 'Проспект Сейфуллина, 617', 100, 10),
('FR2', 'FORUM', 'Проспект Сейфуллина, 617', 70, 10)

INSERT INTO AFISHA VALUES 
('GGV3', '2023-05-04','2023-06-04'),
('SNT', '2023-04-13','2023-05-13'),
('TSMBM', '2023-05-06','2023-06-06'),
('DZHK2', '2023-05-04','2023-06-04')

INSERT INTO AFISHA_DETAIL VALUES
('GGV3','Стражи Галактики. Часть 3','Крис Пратт, Зои Салдана, Дэйв Батиста, Вин Дизель, Брэдли Купер, Карен Гиллан, Пом Клементьефф, Элизабет Дебики, Шон Ганн, Сильвестр Сталлоне',
'Джеймс Ганн','США','PG-13',121,NULL,'фантастика, боевик, приключения, комедия','Супергерои пытаются наладить жизнь Забвения. Однако, спустя немного времени отголоски бурного прошлого Ракеты переворачивают их жизни с ног на голову. Питер Квилл, до сих пор не оправившийся от потери Гаморы, должен сплотить вокруг себя команду, чтобы спасти Ракету. Если Стражи не справятся – это будет означать их конец.',
'MOVIE','RU'),
('SNT',
'Судзумэ, закрывающая двери','Нанока Хара, Хокуто Мацумура, Эри Фукацу, Кана Ханадзава, Котонэ Ханасэ, Косиро Мацумото, Саири Ито, Сёта Сомэтани, Рюносукэ Камики, Акари Миура' ,
'Макото Синкай','Япония','12+',121,NULL, 'фэнтези', '17-летняя Судзумэ живёт в тихом городке на острове Кюсю. Однажды она встречает молодого путешественника, который ищет некую дверь. Вместе они находят старую дверь в горах посреди руин, и заворожённая Судзумэ открывает её. Вскоре загадочные двери открываются по всей Японии, впуская в наш мир различные стихийные бедствия. Чувствуя вину за произошедшее, Судзумэ отправляется в путешествие по неизведанному миру, чтобы закрыть все двери.',
'MOVIE', 'RU'),
('TSMBM', 'Братья Супер Марио в кино', NULL, 'Аарон Хорват, Михаэль Еленик', 'США, Япония', '6+', 92,NULL,'мультфильм, фэнтези, приключения, комедия', 'Водопроводчик Марио отправляется в подземный лабиринт со своим братом Луиджи, чтобы спасти принцессу.', 
'MOVIE', 'RU' )

INSERT INTO SCHEDULED_AFISHA VALUES
('GGV3','MG1','2023-05-12T20:45:00',2500,2000,1500,5000),
('GGV3','MG1','2023-05-12T23:30:00',2000,1100,800,5000),
('SNT','FR1','2023-05-13T12:00:00', 1500,1500,1000,5000),
('TSMBM','FR2','2023-05-12T21:00:00',1500,1500,1500,0)

INSERT INTO RESERVATION VALUES
('87051523434',GETDATE(), 4000, 'ОПЛАЧЕНО')

INSERT INTO RESER_DET VALUES
(1, 1, '20,21', NULL, NULL)

SELECT * FROM RESERVATION;
SELECT * FROM RESER_DET;
SELECT * FROM SCHEDULED_AFISHA;
SELECT * FROM AFISHA;

INSERT INTO AUDITORIUM VALUES
('ALA','Almaty Arena','г. Алматы,  микрорайон Нұркент, 7',2250,25),
('NRTL','Национальный русский театр драмы им. М. Лермонтова','г. Алматы, пр. Абая, 43',665,19),
('ACT','2act','г. Алматы, ТЦ "Ритц-Палас", мкр. Самал-3',160,20),
('CS','Центральный Стадион','г. Алматы, ул. Сатпаева 29/3',2200,25)

INSERT INTO AFISHA VALUES 
('AOO', '2023-03-03','2023-03-04'),
('NY','2023-04-25','2023-05-26' ),
('QMB','2023-05-02','2023-06-26' ),
('CHMD','2023-04-28','2023-05-29' ),
('NFC','2023-03-10','2023-04-11' ),
('FCKA','2023-04-17','2023-05-18' ),
('OITB','2023-05-21','2023-06-10' ),
('PATB','2023-05-20','2023-05-30' )

INSERT INTO AFISHA_DETAIL VALUES
('AOO','Arash | Orda | Outlandish','Arash - ирано, Вакаса Кадри (Waqas Ali Qadri) и Ленни Мартинеса (Lenny Martinez),
Есболат Беделхан, Ерболат Беделхан, Дастан Оразбеков и Нурлан Алымбеков', NULL, NULL, '14+', NULL, NULL,
'music',
'3 легенды на ОДНОЙ сцене!, 
Arash - ирано-шведский певец, танцор, композ итор и продюсер. Сделал дуэт с артистом Snoop Dog, Sean Paul Песни – Arash, 
Dooset Daram, OMG, Pure Love, Broken Angel, Tike Tike Kardi, Temtation, Boro Boro
Outlandish — датская хип-хоп группа. Созданная в 1997 году, она состоит из Вакаса Кадри (Waqas Ali Qadri) и
Ленни Мартинеса (Lenny Martinez) Песни – Aicha, Callin U, Guantanamo, Walou
Orda – основана в 2000 году. Любимцы НАРОДА! 
Солисты группы – Есболат Беделхан, Ерболат Беделхан, Дастан Оразбеков и Нурлан Алымбеков',
'CONCERT','KZ')
INSERT INTO AFISHA_DETAIL VALUES
('NY','Ne-Yo в Алматы','Шейфер Чимер Смит', NULL, NULL,'12+',NULL,NULL, 'music', 
'25 мая 2023 года певец даст единственный сольный концерт в г. Алматы, Казахстан в рамках своего тура по Азии, 
который будет включать в себя такие страны, как Япония, Тайланд, и Сингапур.  
Это событие подарит поклонникам творчества артиста незабываемые впечатления.
Ne-Yo — обладатель Грэмми, американский певец и автор песен в стиле современного R&B и поп-музыки. 
Он писал песни для таких звезд, как Mary J. Blige, Ruben Studdard, Marques Houston, Faith Evans, 
Christina Milian, B2K, Nivea, Tyrese, Rihanna, Jamie Foxx и Heather Headley.
Альбомы исполнителя были проданы общим тиражом свыше 20 миллионов копий. На счету артиста 3 премии Grammy и 14 номинаций.
Его самый известный сингл 2005 года «So Sick» был номером 1 в Billboard Hot 100 и был признан четырежды платиновым.',
'CONCERT','RU')
INSERT INTO AFISHA_DETAIL VALUES
('QMB', 'Qozy men Baian','Айсұлу Әзімбаева, Шыңғыс Капин, Қуантай Әбдімәди, Марат Ягфаров','Пьянова Галина',
'Kazakhstan',NULL, 90, NULL, NULL,'Qozy men Baian - бұл әрқайсымызға таныс ортағасырлық қазақ поэмасының авторлық оқылуы.
Қазақтың фольклорлық дәстүріне негізделген, қазіргі театр тілімен баяндалған махаббат хикаясы мен ғалам туралы 
философиялық астарлы әңгіме.','THEATRICALS','RU')
INSERT INTO AFISHA_DETAIL VALUES
('CHMD', 'ЧеМаДаМ', NULL, 'Виталий Шенгиреев', 'Kazakhstan','3+', 30 ,NULL, NULL, 
'Вы когда-нибудь задумывались насколько удивительно детское воображение?  Какими красочными и яркими могу быть их выдумки?
Кто живёт в чемодане? Дракон? Ураган?
Одна обаятельная девушка-итальянка и её чемодан помогут ответить на эти вопросы.
Детский спектакль, наполненный фокусами и удивительными световыми приёмами.
“…в чемодане пир и сыр
в чемодане целый мир…”','THEATRICALS','RU')
INSERT INTO AFISHA_DETAIL VALUES
('NFC', 'Nomad Fighting Championship', 'Еркебулан Токтар, Фарид Абдуллаев, Васиф Аббасов, Шамиль Галимов', NULL, NULL, '12+', NULL,NULL,
NULL,'10 июня в Алматы Арене состоится грандиозный спортивный турнир по кулачным боям “Nomad Fighting Championship: Великая степь"
Вас ждёт противостояние именитых бойцов:
Еркебулан Токтар - Фарид Ядуллаев
Васиф «Esuriens» Аббасов - Шамиль «Пахан» Галимов
А также финал истории, длительностью более 1,5 года - Гран При организации NOMAD
Мы подготовили большое шоу с выступлениями артистов и розыгрышем призов для зрительского зала,
чтобы сделать этот день настоящим праздником спорта для алмаатинцев','SPORT','RU')
INSERT INTO AFISHA_DETAIL VALUES
('FCKA', 'ФК "Кайрат"  ФК "Атырау"',NULL,NULL,NULL,'0+',120,NULL,NULL,
'17 мая ФК "Кайрат" и ФК "Атырау" соберут лучшие команды в эпической битве за победу. 
Насладитесь невероятной атмосферой болельщиков и наблюдайте, как команды демонстрируют свои лучшие навыки и стремятся стать чемпионами.
Не пропустите этот уникальный шанс увидеть лучших футболистов страны в действии!','SPORT','KZ')
INSERT INTO AFISHA_DETAIL VALUES
('OITB', 'Озеро "Иссык" и Тургеньский водопад',NULL,NULL,NULL,'0+',720, NULL, NULL,
'В стоимость тура включено: транспорт в обе стороны , проживание в гостевых домах,
питание, такси до озеро Кайынды, сопровождающий гид, экологические сборы, вечерняя
программа (дискотека, костер).
Что необходимо взять с собой?
Удостоверение личности или паспорт обязательно перекус, удобную обувь, удобную
одежду, тёплую одежду, наличные деньги, банные принадлежности, носки, сменную одежду (доп.затраты: катание на лошадях, лодка, катамаран)
Время сбора: 21:00, Выезд: 21:30
Место сбора: Абая 50 , парковка цирка вход со стороны ул. Абая
5. Озеро «Иссык» и Тургеньский водопад
Дата поездки
Май: 1, 5, 7, 9, 12, 14, 16, 19, 21, 23, 26, 28,30
В Стоимость тура входит: транспорт, экологические сборы, услуги гида
Мы посещаем:
• Озеро «Иссык»
• Тургенский водопад
• Иссыкский музей
В стоимость тура НЕ входит
Питание (питание можно взять с собой или купить по пути)
Программа тура:
08:00 - Сбор
08:30 - Выезд
11:00 - Пеший поход на Тургеньский водопад
11:30 - Отдых и прогулка в окрестностях
13:00 - Выезд на Форелевое хозяйство
13:30 - Прибытие на Форелевое хозяйство, возможность покушать, отдых
14:30 - Выезд на озеро Иссык
15:00 - Прогулка в округе озера Иссык, время для пикника и отдыха
18:00 - Выезд в город
20:00 - Прибытие в город
* Время указано ориентировочно и может изменятся в зависимости от пунктуальности группы, а также при непредвиденных обстоятельствах!
Что необходимо взять с собой?
Удостоверение личности обязательно, зонтик или дождевик, кепку, ветровку, перекус, удобную обувь, 
удобную одежду, тёплую одежду, наличные деньги (перекус по пути)
📍 Место сбора: Абая 50, парковка цирка
🕘 Время сбора: 8:00
🕘 Время выезда: 8:30','EXCURSION',NULL),
('PATB','Плато Ассы и Тургеньский водопад',NULL,NULL,NULL,'0+',780,NULL,NULL,
'В стоимость тура входит: транспорт, экологические сборы, услуги гида.
*В стоимость тура НЕ входит: питание (питание можно взять с собой или купить по пути).
Программа тура: 
7:30 - сбор; 
8:00 - выезд; 
10:00 - прибытие на Тургеньский водопад (Медвежий); 
12:00 - выезд на плато Ассы; 
13:30 - прибытие на плато Ассы; 
14:00 - дружный пикник с туристами; 
17:00 - выезд в город;  
20:30 - прибытие в город. 
Что необходимо взять с собой: перекус, напитки (не менее 2 л жидкости на одного человека),
солнцезащитный крем и очки, кепку, ветровку, толстовку, дождевик, спортивная обувь.
Контактный номер: +7 777 299 97 67.
Время сбора - 7:30, время выезда - 8:00.
Место сбора: Абая 50, парковка цирка','EXCURSION',NULL)

ALter table AFISHA_DETAIL add cost int
update AFISHA_DETAIL  set cost=100000 where A_code='GGV3'
update  AFISHA_DETAIL  set cost=120000 where A_code='SNT'
update  AFISHA_DETAIL  set cost=130000 where A_code='TSMBM'
update  AFISHA_DETAIL  set cost=140000 where A_code='OITB'
update  AFISHA_DETAIL  set cost=118000 where A_code='PATB'
update  AFISHA_DETAIL  set cost=181000 where A_code='AOO'
update  AFISHA_DETAIL  set cost=205000 where A_code='NY'
update  AFISHA_DETAIL  set cost=245000 where A_code='QMB'
update  AFISHA_DETAIL  set cost=158000 where A_code='CHMD'
update  AFISHA_DETAIL  set cost=176000 where A_code='NFC'
update  AFISHA_DETAIL  set cost=105000 where A_code='FCKA'


END

EXEC BUILDER

DROP PROCEDURE BUILDER

SELECT * FROM SCHEDULED_AFISHA
SELECT * FROM RESER_DET
SELECT * FROM RESERVATION
SELECT * FROM AFISHA_DETAIL

-- FIRST PROCEDURE

CREATE PROCEDURE PR_PURCHASE_OF_TICKETS(@SA_ID INT, @SEATS VARCHAR(MAX), @CUST_ID VARCHAR(MAX))
AS 
BEGIN
  DECLARE @NUM VARCHAR(MAX) = (SELECT dbo.fn_GetNumbers(@SEATS))
  DECLARE @TYPE VARCHAR(MAX) = (SELECT dbo.fn_GET_ENSTR(@SEATS))

  DECLARE @LEN_TYPE_K INT = (SELECT LEN(REPLACE((REPLACE(REPLACE(@TYPE, 'V', ''), 'A', '')), 'S', '')))
  DECLARE @LEN_TYPE_S INT = (SELECT LEN(REPLACE((REPLACE(REPLACE(@TYPE, 'V', ''), 'A', '')), 'K', '')))
  DECLARE @LEN_TYPE_A INT = (SELECT LEN(REPLACE((REPLACE(REPLACE(@TYPE, 'V', ''), 'K', '')), 'S', '')))
  DECLARE @LEN_TYPE_V INT = (SELECT LEN(REPLACE((REPLACE(REPLACE(@TYPE, 'K', ''), 'A', '')), 'S', '')))
  

  DECLARE @TOTAL INT = @LEN_TYPE_K * (SELECT PRICE_KID FROM SCHEDULED_AFISHA WHERE SA_ID = @SA_ID) + 
					   @LEN_TYPE_S * (SELECT PRICE_STUDENT FROM SCHEDULED_AFISHA WHERE SA_ID = @SA_ID) +
					   @LEN_TYPE_A * (SELECT PRICE_ADULT FROM SCHEDULED_AFISHA WHERE SA_ID = @SA_ID) +
					   @LEN_TYPE_V * (SELECT PRICE_VIP FROM SCHEDULED_AFISHA WHERE SA_ID = @SA_ID)


	INSERT INTO RESERVATION VALUES (@CUST_ID, GETDATE(), @TOTAL, 'НЕ ОПЛАЧЕНО')
	INSERT INTO RESER_DET (RES_ID, SA_ID, SEAT_NUM) VALUES ((SELECT TOP 1 RES_ID FROM RESERVATION ORDER BY RES_ID DESC), @SA_ID, @NUM)

	DECLARE @RES_ID INT = (SELECT TOP 1 RES_ID FROM RESERVATION ORDER BY RES_ID DESC)
	PRINT dbo.fn_INVOICE(@RES_ID)

END

EXEC PR_PURCHASE_OF_TICKETS @SA_ID = 1, @SEATS = '16K, 17A, 18A, 19S', @CUST_ID = '87055675677'

SELECT LEN(REPLACE((REPLACE(REPLACE('KAS', 'V', ''), 'A', '')), 'S', ''))

DELETE FROM RESER_DET WHERE RES_ID = 1 AND SA_ID=4
DELETE FROM RESERVATION WHERE RES_ID=9

UPDATE RESERVATION
SET PAID = 'ОПЛАЧЕНО'
WHERE RES_ID = 4

SELECT * FROM RESER_DET
SELECT * FROM RESERVATION

DROP PROCEDURE PR_PURCHASE_OF_TICKETS

ALTER TABLE RESER_DET
ALTER COLUMN SEAT_NUM VARCHAR(MAX)

  DECLARE @NUM VARCHAR(MAX) = (SELECT dbo.fn_GetNumbers(@SEATS))
  DECLARE @TYPE VARCHAR(MAX) = (SELECT dbo.fn_GET_ENSTR(@SEATS))

  --K

ALTER TABLE RESER_DET
DROP COLUMN SEAT_PRICE

SELECT LEN(REPLACE((REPLACE(REPLACE('KAKVS', 'V', ''), 'A', '')), 'S', ''))

--FUNCTIONS FOR 1ST PROCEDURE


CREATE FUNCTION fn_CheckSeatsAvailability
(
    @sa_id INT,
    @seat_nums VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @available_seats VARCHAR(MAX) = ''
    
    SELECT @available_seats = @available_seats + CAST(sd.SEAT_NUM AS VARCHAR(10)) + ', '
    FROM SCHEDULED_AFISHA sa
    INNER JOIN RESERVATION r ON sa.SA_ID = r.SA_ID
    INNER JOIN RESER_DET sd ON r.RES_ID = sd.RES_ID
    WHERE sa.SA_ID = @sa_id AND sd.SEAT_NUM IN (SELECT value FROM STRING_SPLIT(@seat_nums, ','))
    
    IF LEN(@available_seats) > 0
        SET @available_seats = 'Seat(s) ' + LEFT(@available_seats, LEN(@available_seats) - 1) + ' are not available.'
    ELSE
        SET @available_seats = 'All requested seats are available.'
    
    RETURN @available_seats
END

PRINT dbo.fn_CheckSeatsAvailability(1, '20,1')


CREATE FUNCTION fn_GetNumbers (@stInput VARCHAR(max))
RETURNS VARCHAR(max)
AS
BEGIN
    SET @stInput = REPLACE(@stInput,',','')
     
    DECLARE @intAlpha INT
    DECLARE @intNumber INT
 
    SET @intAlpha = PATINDEX('%[^0-9,]%', @stInput)
    SET @intNumber = PATINDEX('%[0-9,]%', @stInput)
 
    IF @stInput IS NULL OR @intNumber = 0
        RETURN '';
 
    WHILE @intAlpha > 0 
    BEGIN
        IF (@intAlpha > @intNumber)
        BEGIN
            SET @intNumber = PATINDEX('%[0-9,]%', SUBSTRING(@stInput, @intAlpha, LEN(@stInput)) )
            SELECT @intNumber = CASE WHEN @intNumber = 0 THEN LEN(@stInput) ELSE @intNumber END
        END
 
        SET @stInput = STUFF(@stInput, @intAlpha, @intNumber - 1,',' );
             
        SET @intAlpha = PATINDEX('%[^0-9,]%', @stInput )
        SET @intNumber = PATINDEX('%[0-9,]%', SUBSTRING(@stInput, @intAlpha, LEN(@stInput)) )
        SELECT @intNumber = CASE WHEN @intNumber = 0 THEN LEN(@stInput) ELSE @intNumber END
    END
     
 
    IF (RIGHT(@stInput, 1) = ',')
        SET @stInput = LEFT(@stInput, LEN(@stInput) - 1)
 
    IF (LEFT(@stInput, 1) = ',')
        SET @stInput = RIGHT(@stInput, LEN(@stInput) - 1)
 
    RETURN ISNULL(@stInput,0)
END
GO


SELECT dbo.fn_GetNumbers('1K, 2A, 21S')


CREATE FUNCTION dbo.fn_GET_ENSTR (@S VARCHAR(100))
RETURNS VARCHAR(100)
AS
BEGIN
    WHILE PATINDEX('%[^a-z]%', @S) > 0
    BEGIN
        SET @S = STUFF(@S, PATINDEX('%[^a-z]%', @S), 1, '');
    END;
    RETURN @S;
END;


SELECT dbo.fn_GET_ENSTR('1K, 2K, 21S')

DROP FUNCTION dbo.fn_GET_ENSTR

SELECT STUFF('1K, 2K, 21S', PATINDEX(CONCAT('[^', 'K', ']'), '1K, 2K, 21S'), 1, '');
SELECT STUFF('1K, 2K, 21S', PATINDEX('[^a-z]+', '1K, 2K, 21S'), 1, '');


--3 PROCEDURE

CREATE PROCEDURE CalculateMonthlyProfit
@month INT, @year INT
AS
BEGIN
	DECLARE @startDate DATE = DATEFROMPARTS(@year, @month, 1)
    DECLARE @endDate DATE = DATEADD(DAY, -1, DATEADD(MONTH, 1, @startDate))

	 -- Calculation of monthly income
    DECLARE @income DECIMAL(10, 2) = (
        SELECT SUM(TOTAL)
        FROM RESERVATION
        WHERE RES_DATE BETWEEN @startDate AND @endDate
    )

	-- Calculation of expenses for the month
    DECLARE @expenses DECIMAL(10, 2) = (
        SELECT SUM(AD.COST)
        FROM AFISHA_DETAIL AD
		JOIN AFISHA A
		ON AD.A_CODE = A.A_CODE
        WHERE START_DATE BETWEEN @startDate AND @endDate
    )

	-- Calculation of net profit
    DECLARE @netProfit DECIMAL(10, 2) = @income - @expenses 

	-- Output of results
    SELECT @income AS Income, @expenses AS Expenses, @netProfit AS NetProfit

END

EXEC CalculateMonthlyProfit @month = 5, @year = 2023

DROP PROCEDURE CalculateMonthlyProfit

SELECT * FROM RESERVATION;
SELECT * FROM RESER_DET;

--TRIGGER BOOKING TIME
CREATE TRIGGER BOOKING_TIME
ON RESERVATION
AFTER INSERT
AS
BEGIN
  IF DATEDIFF(MI, (SELECT RES_DATE FROM RESERVATION WHERE RES_ID = (SELECT TOP 1 RES_ID FROM (SELECT TOP 2 * FROM RESERVATION ORDER BY RES_ID DESC) x ORDER BY RES_ID)), getdate()) > 14
    BEGIN
    UPDATE RESERVATION
    SET PAID = 'ОПЛАЧЕНО'
	WHERE RES_ID = (SELECT TOP 1 RES_ID FROM (SELECT TOP 2 * FROM RESERVATION ORDER BY RES_ID DESC) x ORDER BY RES_ID)
    END
END

DROP TRIGGER BOOKING_TIME

SELECT DATEDIFF(MI, '2023-05-11 22:58:03.737', getdate())

-- !!!!!!!!!!!!! BOOKIND FUNC AND TRIGGER

CREATE FUNCTION check_status (@date datetime)
RETURNS varchar(10)
AS
BEGIN
  DECLARE @status varchar(10)
  IF DATEDIFF(MINUTE, @date, GETDATE()) > 15
  BEGIN
    SET @status = 'ОПЛАЧЕНО'
  END
  ELSE
  BEGIN
    SET @status = 'НЕ ОПЛАЧЕНО'
  END
  RETURN @status
END

CREATE TRIGGER BOOKING 
ON RESERVATION
AFTER INSERT
AS
BEGIN
	DECLARE @S VARCHAR(10) = dbo.check_status((SELECT RES_DATE FROM RESERVATION WHERE RES_ID = (SELECT TOP 1 RES_ID FROM (SELECT TOP 2 * FROM RESERVATION ORDER BY RES_ID DESC) x ORDER BY RES_ID)))
	UPDATE RESERVATION
	SET PAID = @S
	WHERE RES_ID = (SELECT TOP 1 RES_ID FROM (SELECT TOP 2 * FROM RESERVATION ORDER BY RES_ID DESC) x ORDER BY RES_ID)
END

-- INVOICE

CREATE FUNCTION fn_INVOICE (@RES_ID INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @NAME VARCHAR(50) = (SELECT C.FULLNAME FROM RESERVATION R JOIN CUSTOMER C ON R.CUST_ID = C.CUST_ID WHERE RES_ID = @RES_ID)
	DECLARE @M_NANE VARCHAR(MAX) = (SELECT AD.NAME FROM AFISHA_DETAIL AD JOIN SCHEDULED_AFISHA SA ON AD.A_CODE = SA.A_CODE 
									JOIN RESER_DET RD ON SA.SA_ID = RD.SA_ID WHERE RES_ID = @RES_ID)
	DECLARE @SEANS_TIME VARCHAR(MAX) = CONVERT(VARCHAR(MAX),(SELECT SA.SEANS_TIME FROM SCHEDULED_AFISHA SA JOIN RESER_DET RD ON SA.SA_ID = RD.SA_ID WHERE RES_ID = @RES_ID))
	DECLARE @AUD_ID VARCHAR(10) = (SELECT A.AUD_ID FROM AUDITORIUM A JOIN SCHEDULED_AFISHA SA ON A.AUD_ID = SA.AUD_ID JOIN RESER_DET RD 
										ON SA.SA_ID = RD.SA_ID WHERE RES_ID = @RES_ID)
	DECLARE @SEAT_NUM VARCHAR(MAX) = (SELECT SEAT_NUM FROM RESER_DET WHERE RES_ID = @RES_ID)
	DECLARE @TOTAL VARCHAR(MAX) = CONVERT(VARCHAR(10), (SELECT TOTAL FROM RESERVATION WHERE RES_ID = @RES_ID))
	
	RETURN 'ЧЕК: ' + @NAME + char(10) + 'Название фильма: ' +  @M_NANE + char(10)+ 'Время: ' + @SEANS_TIME +char(10)+ 'Зал:' + @AUD_ID +  char(10)+'Место: ' + @SEAT_NUM + char(10)+'Итого: ' + @TOTAL
END

PRINT dbo.fn_INVOICE(1)

DROP FUNCTION fn_INVOICE



--Отзывы
GO
CREATE function RATING_CALCULATOR(@A_CODE VARCHAR(30))
RETURNS FLOAT
BEGIN
RETURN
	(SELECT AVG(RATING) FROM RESER_DET D
	JOIN SCHEDULED_AFISHA S ON S.SA_ID=D.SA_ID
	WHERE S.A_CODE=@A_CODE)
END
GO


CREATE TRIGGER RATING_TRIGGER
ON RESER_DET
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
UPDATE AFISHA_DETAIL
	SET REV_KINOKZ = dbo.RATING_CALCULATOR(A_CODE)
END

UPDATE RESER_DET
SET RATING=9
WHERE SA_ID=1 AND SEAT_NUM='20,21'


UPDATE RESER_DET
SET RATING=10
WHERE SA_ID=1
UPDATE RESER_DET
SET RATING=9
WHERE SA_ID=1 AND SEAT_NUM=21

--возврат
GO
CREATE PROCEDURE TICKET_REFUND(@RES_ID INT)
AS
BEGIN
    SET NOCOUNT ON;
	IF 	DATEDIFF(HOUR,getdate(),(SELECT TOP 1 SEANS_TIME FROM SCHEDULED_AFISHA S JOIN RESER_DET D ON D.SA_ID=S.SA_ID WHERE D.RES_ID=@RES_ID)) > 3
		BEGIN
			DELETE FROM RESERVATION
			WHERE RES_ID=@RES_ID
			PRINT 'ВОЗВРАЩЕНО'
		END
	ELSE 
		BEGIN 
		PRINT 'ВОЗВРАТ НЕВОЗМОЖЕН.'
		PRINT 'ПРОЧИТАЙТЕ ПРАВИЛА ВОЗВРАТА.'
		PRINT 'БИЛЕТ МОЖНО СДАТЬ ЗА 3 ЧАСА ДО СЕАНСА'
	END
END
GO

DROP PROCEDURE TICKET_REFUND
EXEC TICKET_REFUND @RES_ID=5

SELECT * FROM RESERVATION;
SELECT * FROM RESER_DET;


SELECT * FROM RESERVATION 
WHERE RES_ID not in (SELECT TOP (SELECT COUNT(1)-1
                             FROM RESERVATION) 
                        RES_ID 
                 FROM RESERVATION)

SELECT TOP 1 RES_ID FROM (SELECT TOP 2 * FROM RESERVATION ORDER BY RES_ID DESC) x ORDER BY RES_ID