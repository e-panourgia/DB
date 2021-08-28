
USE DB127;


---- QUESTION 2 ----

GO

CREATE PROCEDURE GetSupplyBetweenDate
(@PrCode varchar(15),
 @SupplyDateFrom date,
 @SupplyDateUntil date
)
AS
BEGIN

SET NOCOUNT ON;

DECLARE @Name varchar(60), @Date date, @ShipCode varchar(15), @Amount int;

DECLARE CursorPrint CURSOR FOR

(SELECT p.Name, s.[Date], s.ShipCode, s.Amount
 FROM Product p, Supply s
 WHERE p.PrCode = s.PrCode AND
		p.PrCode = @PrCode AND
		s.[Date] BETWEEN @SupplyDateFrom AND @SupplyDateUntil)
		
OPEN CursorPrint;

FETCH NEXT FROM CursorPrint
INTO @Name, @Date, @ShipCode, @Amount;

WHILE @@FETCH_STATUS = 0
BEGIN

PRINT '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
PRINT 'Product Description: ' + @Name
PRINT 'Supply Code: ' + @ShipCode
PRINT 'Amount: ' + CAST(@Amount AS VARCHAR)
PRINT 'Date: ' + CAST(@Date AS VARCHAR)
PRINT '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'

FETCH NEXT FROM CursorPrint
INTO @Name, @Date, @ShipCode, @Amount;

END

CLOSE CursorPrint;
DEALLOCATE CursorPrint;

END





EXEC GetSupplyBetweenDate @PrCode = 'GD76543000012', @SupplyDateFrom = '2012-01-01', @SupplyDateUntil = '2014-01-01';


drop procedure GetSupplyBetweenDate;





  SELECT p.Name, s.[Date], s.ShipCode, s.Amount, p.PrCode, p.Descr
  FROM Product p, Supply s
  WHERE p.PrCode = s.PrCode AND
		p.PrCode = 'GD76543000012' AND
		s.[Date] BETWEEN '2012-01-01' AND '2014-01-01'


 SELECT *
 FROM Product p
