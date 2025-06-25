-- Q1: List of all customers
SELECT * FROM Sales.Customer;

-- Q2: List of all customers where company name ends with 'N'
SELECT c.CustomerID, s.Name AS CompanyName
FROM Sales.Customer c
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE s.Name LIKE '%N';

-- Q3: List of all customers who live in Berlin or London
SELECT c.*
FROM Sales.Customer c
JOIN Person.Address a ON c.CustomerID = a.AddressID
WHERE a.City IN ('Berlin', 'London');

-- 4. List of all customers who live in UK or USA
SELECT * FROM Person.Address a
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name IN ('United Kingdom', 'United States');

-- Q5: List of all products sorted by product name
SELECT * FROM Production.Product ORDER BY Name;

-- Q6: List of all products where product name starts with an 'A'
SELECT * FROM Production.Product WHERE Name LIKE 'A%';

-- Q7: List of customers who ever placed an order
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person  ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader sh ON c.CustomerID = soh.CustomerID;

-- Q8: List of customers who live in London and have bought Chai
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.CustomerAddress ca ON c.CustomerID = ca.CustomerID
JOIN Person.Address a ON ca.AddressID = a.AddressID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE a.City = 'London' AND pr.Name = 'Chai';

-- Q9: List of customers who never placed an order
SELECT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE soh.CustomerID IS NULL;

-- Q10: List of customers who ordered Tofu
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE pr.Name = 'Tofu';

-- Q11: Details of first order of the system
SELECT TOP 1 * FROM Sales.SalesOrderHeader ORDER BY OrderDate ASC;

-- Q12: Find the details of most expensive order date
SELECT TOP 1 OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- Q13: For each order get the OrderID and average quantity of items in that order
SELECT SalesOrderID, AVG(OrderQty) AS AvgQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- Q14: For each order get the orderID, minimum quantity and maximum quantity for that order
SELECT SalesOrderID, MIN(OrderQty) AS MinQty, MAX(OrderQty) AS MaxQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- Q15: List of all managers and the total number of employees who report to them
SELECT 
    mgr.BusinessEntityID AS ManagerID,
    pm.FirstName AS ManagerFirstName,
    pm.LastName AS ManagerLastName,
    COUNT(e.BusinessEntityID) AS NumEmployees
FROM HumanResources.Employee e
JOIN HumanResources.Employee mgr ON e.OrganizationNode.GetAncestor(1) = mgr.OrganizationNode
JOIN Person.Person pm ON mgr.BusinessEntityID = pm.BusinessEntityID
GROUP BY mgr.BusinessEntityID, pm.FirstName, pm.LastName
ORDER BY NumEmployees DESC;

-- Q16: Get the OrderID and the total quantity for each order that has a total quantity of greater than 300
SELECT SalesOrderID, SUM(OrderQty) AS TotalQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;

-- Q17: List of all orders placed on or after 1996/12/31
SELECT * FROM Sales.SalesOrdeHeader
WHERE OrderDate >= '1996-12-31';

-- Q18: List of all orders shipped to Canada
SELECT soh.SalesOrderID, soh.OrderDate, a.AddressLine1, sp.CountryRegionCode
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'CA';

-- Q19: List of all orders with order total > 200
SELECT * FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

-- Q20: List of countries and sales made in each country
SELECT sp.CountryRegionCode, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
GROUP BY sp.CountryRegionCode;

-- Q21: List of Customer ContactName and number of orders they placed
SELECT p.FirstName + ' ' + p.LastName AS ContactName, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName;

-- Q22: List of customer contactnames who have placed more than 3 orders
SELECT p.FirstName + ' ' + p.LastName AS ContactName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 3;

-- Q23: List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
SELECT DISTINCT p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.DiscontinuedDate IS NOT NULL
  AND soh.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

-- Q24: Employee firstname, lastname, supervisor firstname, lastname
SELECT 
    e.BusinessEntityID AS EmployeeID,
    pe.FirstName AS EmployeeFirstName,
    pe.LastName AS EmployeeLastName,
    mgr.BusinessEntityID AS SupervisorID,
    pm.FirstName AS SupervisorFirstName,
    pm.LastName AS SupervisorLastName
FROM HumanResources.Employee e
JOIN Person.Person pe ON e.BusinessEntityID = pe.BusinessEntityID
LEFT JOIN HumanResources.Employee mgr ON e.OrganizationNode.GetAncestor(1) = mgr.OrganizationNode
LEFT JOIN Person.Person pm ON mgr.BusinessEntityID = pm.BusinessEntityID
WHERE e.OrganizationNode.GetAncestor(1) IS NOT NULL;

-- Q25: List of Employees id and total sale conducted by employee
SELECT soh.SalesPersonID AS EmployeeID, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
WHERE soh.SalesPersonID IS NOT NULL
GROUP BY soh.SalesPersonID;

-- Q26: List of employees whose FirstName contains character 'a'
SELECT * FROM Person.Person
WHERE FirstName LIKE '%a%';

-- Q27: Managers who have more than four people reporting to them
SELECT 
    mgr.BusinessEntityID aS ManagerID,
    pm.FirstName AS ManagerFirstName,
    pm.LastName AS ManagerLastName,
    COUNT(e.BusinessEntityID) AS NumReports
FROM HumanResources.Employee e
JOIN HumanResources.Employee mgr ON e.OrganizationNode.GetAncestor(1) = mgr.OrganizationNode
JOIN Person.Person pm ON mgr.BusinessEntityID = pm.BusinessEntityID
GROUP BY mgr.BusinessEntityID, pm.FirstName, pm.LastName
HAVING COUNT(e.BusinessEntityID) > 4
ORDER BY NumReports DESC;

-- Q28: List of Orders and ProductNames
SELECT soh.SalesOrderID, pr.Name AS ProductName
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID;

-- Q29: List of orders placed by the best customer (highest total purchases)
WITH BestCustomer AS (
    SELECT TOP 1 CustomerID
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
    ORDER BY SUM(TotalDue) DESC
)
SELECT soh.*
FROM Sales.SalesOrderHeade soh
WHERE soh.CustomerID = (SELECT CustomerID FROM BestCustomer);

-- Q30: List of orders placed by customers who do not have a Fax number
SELECT soh.SalesOrderID, soh.OrderDate, c.CustomerID
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID AND pp.PhoneNumberTypeID = 3
WHERE pp.PhoneNumber IS NULL;

-- Q31: List of Postal codes where the product Tofu was shipped
SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderHeaer soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE pr.Name = 'Tofu';

-- Q32: List of product names that were shipped to France
SELECT DISTINCT pr.Name
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'FR';

-- Q33: List of ProductNames and Categories for the supplier 'Specialty Biscuits, Ltd.'
SELECT p.Name AS ProductName, pc.Name AS CategoryName
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';

-- Q34: List of products that were never ordered
SELECT p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

-- Q35: List of products where units in stock is less than 10 and units on order are 0
SELECT Name
FROM Production.Product
WHERE SafetyStockLevel < 10 AND ReorderPoint = 0;

-- Q36: List of top 10 countries by sales
SELECT TOP 10 sp.CountryRegionCode, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
GROUP BY sp.CountryRegionCode
ORDER BY TotalSales DESC;

-- Q37: Number of orders each employee has taken for customers with CustomerIDs between 'A' and 'AO'
-- (Assuming CustomerID is numeric, adjust if not)
SELECT soh.SalesPersonID AS EmployeeID, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
WHERE soh.CustomerID BETWEEN 1 AND 40 -- Replace with actual IDs for 'A' and 'AO' if needed
GROUP BY soh.SalesPersonID;

-- Q38: Orderdate of most expensive order
SELECT TOP 1 OrderDate
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- Q39: Product name and total revenue from that product
SELECT pr.Name, SUM(sod.LineTotal) AS TotalRevenue
FROM Production.Productpr
JOIN Sales.SalesOrderDetail sod ON pr.ProductID = sod.ProductID
GROUP BY pr.Name;

-- Q40: Supplierid and number of products offered
SELECT pv.BusinessEntityID AS SupplierID, COUNT(pv.ProductID) AS ProductCount
FROM Purchasing.ProductVendor pv
GROUP BY pv.BusinessEntityID;

-- Q41: Top ten customers based on their business
SELECT TOP 10 c.CustomerID, SUM(soh.TotalDue) AS TotalSpent
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC;

-- Q42: What is the total revenue of the company
SELECT SUM(TotalDu) AS TotalRevenue
FROM Sales.SalesOrderHeader;
