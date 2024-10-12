/*
	SUBQUERY - INNER QUERY
	1- Select list'te kullanýlabilir.
	2- From Clause'da kullanýlabilir.
	3- Where Clause'da kullanýlabilir.
*/

SELECT * FROM Orders ORDER BY CustomerID
-- Her bir customer'ýn sipariþ adedi
SELECT CustomerID, COUNT(CustomerID) [Total Order Count]
FROM Orders
GROUP BY CustomerID
ORDER BY [Total Order Count]

SELECT * FROM Orders
SELECT * FROM Customers
SELECT * FROM [Order Details]
SELECT * FROM Products
-- Her bir customer için product adedi
SELECT C.CustomerID, C.CompanyName, COUNT(O.CustomerID) [Order Count], SUM(OD.Quantity) [Product Count]
FROM Customers C INNER JOIN Orders O ON C.CustomerID = O.CustomerID 
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY C.CustomerID, C.Companyname
ORDER BY CustomerId
-- HAVING C.CustomerId = 'ALFKI'

SELECT * FROM Customers
-- Subquery ile her bir customer'ýn sipariþ adedi
SELECT CustomerID, CompanyName,
(
	SELECT [Total Order Count]
	FROM
	(
		SELECT CustomerID, COUNT(CustomerID) [Total Order Count]
		FROM Orders
		WHERE CustomerID = 'ALFKI'
		GROUP BY CustomerID
	) [Customer Order Count]
) [Total Order Count]
FROM Customers
WHERE CustomerID = 'ALFKI'

-- Subquery bir customer için product adedi
SELECT CustomerID, CompanyName,
(
	SELECT [Total Order Count]
	FROM
	(
		SELECT CustomerID, COUNT(CustomerID) [Total Order Count]
		FROM Orders
		WHERE CustomerID = 'ALFKI'
		GROUP BY CustomerID
	) [Customer Order Count]
) [Total Order Count],
(
	SELECT [Product Count]
	FROM
	(
		SELECT C.CustomerID, SUM(OD.Quantity) [Product Count]
		FROM Customers C INNER JOIN Orders O ON C.CustomerID = O.CustomerID 
		INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
		INNER JOIN Products P ON P.ProductID = OD.ProductID
		GROUP BY C.CustomerID, C.Companyname
		HAVING C.CustomerId = 'ALFKI'
	) [Customer Product Count]
)[ProductCount]
FROM Customers
WHERE CustomerID = 'ALFKI'

SELECT * FROM Orders
WHERE EmployeeID IN
(
	SELECT EmployeeID FROM Employees WHERE FirstName LIKE '[A-K]%'
)


SELECT * FROM Suppliers
SELECT * FROM Products

SELECT ProductID, ProductName 
FROM Products
WHERE SupplierID IN (
	SELECT SupplierID FROM Suppliers WHERE Country IN('UK', 'USA', 'Germany')
)

SELECT P.ProductID, P.ProductName, S.Country 
FROM Products P INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
WHERE P.SupplierID IN (
	SELECT SupplierID FROM Suppliers WHERE Country IN('UK', 'USA', 'Germany')
)

SELECT C.CustomerID, C.CompanyName, CusOrdCount.[Order Count], CusProdCount.[Product Count]
FROM Customers C INNER JOIN
(
	SELECT CustomerID, COUNT(CustomerID) [Order Count]
	FROM Orders 
	GROUP BY CustomerID
) CusOrdCount ON C.CustomerID = CusOrdCount.CustomerID
INNER JOIN
(
	SELECT C.CustomerID, SUM(OD.Quantity) [Product Count]
	FROM Customers C INNER JOIN Orders O ON C.CustomerID = O.CustomerID 
	INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
	INNER JOIN Products P ON P.ProductID = OD.ProductID
	GROUP BY C.CustomerID, C.Companyname
) CusProdCount ON C.CustomerID = CusProdCount.CustomerID