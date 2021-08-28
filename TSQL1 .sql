USE DB127;

---- QUESTION 1 ----

GO

CREATE PROCEDURE CustomerPerGeo
(@GCode int
)
AS
BEGIN

SET NOCOUNT ON;

(SELECT GCode, COUNT(CustCode) AS NumOfCustomers
FROM Customer
WHERE GCode = @GCode
GROUP BY GCode)

END



EXEC CustomerPerGeo @GCode = 1;

drop procedure CustomerPerGeo;

SELECT GCode, COUNT(CustCode) AS NumOfCustomers
FROM Customer
WHERE GCode = 8
GROUP BY GCode

SELECT *
FROM Customer