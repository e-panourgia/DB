USE DB127;

/*QUESTION 1:*/

SELECT CustCode,Afm, CompName,City, Street, Num, Zip, Phone
 FROM Customer;


/*QESTION 2:*/


SELECT CustCode,PayAmnt
FROM Payment
WHERE PayDate BETWEEN '2012-05-12' AND '2012-05-22'


/*QUESTION 3:*/

SELECT o.OrdDate, o.OrdCode, co.PrCode
FROM Orderr AS o, ConsistOf AS co
WHERE o.OrdCode = co.OrdCode


/*QUESTION 4:*/

UPDATE Product
SET Price = Price * 1.03


/*QUESTION 5:*/

SELECT MONTH(PayDate) AS [Month],
		SUM(PayAmnt) AS TotalMonthlyPayments,
		AVG(PayAmnt) AS AvgMonthlyPayments
FROM Payment
WHERE YEAR(PayDate) = 2012
GROUP BY MONTH(PayDate)


/*QUESTION 6:*/

SELECT c.Afm, c.CompName 
FROM Customer AS c,Orderr AS o, ConsistOf AS co,Product AS p
WHERE c.CustCode = o.CustCode AND o.OrdCode = co.OrdCode AND co.PrCode = p.PrCode AND
		YEAR(OrdDate) = 2013 AND MONTH(OrdDate) = 1 
GROUP BY c.Afm, c.CompName
HAVING SUM(p.Price * co.Amount) > 2500


/*QUESTION 7:*/

SELECT  o.CustCode, p.CatCode, SUM(co.Amount * p.Price) AS CatTotalCost
FROM Orderr o, ConsistOf co, Product p
WHERE o.OrdCode = co.OrdCode AND p.PrCode = co.PrCode
GROUP BY p.CatCode, o.CustCode


/*QUESTION 8:*/

SELECT c.GCode, p.CatCode, AVG(co.Amount * p.Price) as AvgSales
FROM Product p, ConsistOf co, Customer c, Orderr o
WHERE p.PrCode = co.PrCode AND c.CustCode = o.CustCode AND o.OrdCode = co.OrdCode
GROUP BY c.GCode, p.CatCode


/*QUESTION 9:*/

SELECT MONTH(o.OrdDate) Month2012,
		SUM(co.Amount * p.Price) / (SELECT SUM(co.Amount * p.Price)
								FROM Orderr AS o, ConsistOf AS co, Product AS p
								WHERE co.OrdCode = o.OrdCode AND p.PrCode = co.PrCode AND
								YEAR(o.OrdDate) = 2012) AS Pct
FROM Orderr AS o, ConsistOf AS co, Product AS p
WHERE co.OrdCode = o.OrdCode AND p.PrCode = co.PrCode AND
		YEAR(o.OrdDate) = 2012
GROUP BY MONTH(o.OrdDate)


/*QUESTION 10:*/

CREATE VIEW AvgMonthlySales
AS
SELECT MONTH(o.OrdDate) AS [Month],
		AVG(co.Amount * p.Price) AS AvgSales
FROM Orderr AS o, ConsistOf AS co, Product AS p
WHERE o.OrdCode = co.OrdCode AND p.PrCode = co.PrCode
GROUP BY MONTH(o.OrdDate)

CREATE VIEW AvgMonthlySalesPerCustomer
AS
SELECT MONTH(o.OrdDate) AS [Month],
		o.CustCode, AVG(co.Amount * p.Price)  AS AvgSales
FROM Orderr AS o, ConsistOf AS co, Product AS p
WHERE o.OrdCode = co.OrdCode AND p.PrCode = co.PrCode
GROUP BY MONTH(o.OrdDate), o.CustCode


SELECT c.[Month], COUNT(c.CustCode) AS NrCustomers
FROM AvgMonthlySalesPerCustomer c, AvgMonthlySales t
WHERE t.[Month] = c.[Month] AND c.AvgSales > t.AvgSales
GROUP BY c.[Month]


/*QUESTION 11:*/

CREATE VIEW TotalMonthlySalePerYear
AS
SELECT YEAR(o.OrdDate) AS [Year],
		MONTH(o.OrdDate) AS [Month],
		SUM(co.Amount*p.Price) TotalSales
FROM Orderr AS o, ConsistOf AS co, Product AS p
WHERE co.OrdCode = o.OrdCode AND p.PrCode = co.PrCode
GROUP BY YEAR(o.OrdDate), MONTH(o.OrdDate)

SELECT Sales2011.[Month],
		Sales2011.TotalSales AS TotalSales2011,
		Sales2012.TotalSales AS TotalSales2012,
		(Sales2012.TotalSales / Sales2011.TotalSales * 100) AS SalesPct
FROM (SELECT * FROM TotalMonthlySalePerYear WHERE [Year] = 2011) AS Sales2011,
	(SELECT * FROM TotalMonthlySalePerYear WHERE [Year] = 2012) AS Sales2012
WHERE Sales2011.[Month] = Sales2012.[Month]


/*QUESTION 12:*/

CREATE VIEW AvgMonthlySalesPerYear
AS
SELECT YEAR(o.OrdDate) AS [Year],
	MONTH(o.OrdDate) AS [Month],
	AVG(co.Amount*p.Price) AS AvgSales
FROM Orderr AS o, ConsistOf AS co, Product AS p
WHERE co.OrdCode = o.OrdCode AND p.PrCode = co.PrCode
GROUP BY YEAR(o.OrdDate),
		MONTH(o.OrdDate)

SELECT s.*,
	(SELECT AVG(co.Amount * p.Price)
	FROM Orderr AS o, ConsistOf AS co, Product AS p
	WHERE co.OrdCode = o.OrdCode AND p.PrCode = co.PrCode AND
			YEAR(o.OrdDate) = s.[Year] AND
			MONTH(o.OrdDate) < s.[Month]
	GROUP BY YEAR(o.OrdDate)) AS PreviousMonthsAVGSales
FROM AvgMonthlySalesPerYear AS s
WHERE s.[Year] = 2012


/*QUESTION 13:*/

SELECT DISTINCT s.PrCode
FROM Supply AS s, Supplier AS su
WHERE su.SupCode = s.SupCode
GROUP BY s.PrCode
HAVING COUNT(DISTINCT su.GCode) = 1


/*QUESTION 14:*/

SELECT DISTINCT co.OrdCode
FROM ConsistOf co, Supply s
WHERE co.PrCode = s.PrCode
GROUP BY co.OrdCode, s.SupCode
HAVING COUNT(DISTINCT co.PrCode) >2

