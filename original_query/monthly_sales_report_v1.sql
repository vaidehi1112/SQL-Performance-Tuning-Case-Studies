WITH CustomerRevenue AS
(
    SELECT
        c.CustomerID,
        c.CustomerName,
        YEAR(o.OrderDate) AS OrderYear,
        MONTH(o.OrderDate) AS OrderMonth,
        SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM Orders o
    INNER JOIN OrderItems oi
        ON o.OrderID = oi.OrderID
    INNER JOIN Customers c
        ON o.CustomerID = c.CustomerID
    WHERE YEAR(o.OrderDate) = 2024
    GROUP BY
        c.CustomerID,
        c.CustomerName,
        YEAR(o.OrderDate),
        MONTH(o.OrderDate)
),
RankedCustomers AS
(
    SELECT
        *,
        RANK() OVER
        (
            PARTITION BY OrderMonth
            ORDER BY Revenue DESC
        ) AS RevenueRank
    FROM CustomerRevenue
)
SELECT
    CustomerID,
    CustomerName,
    OrderMonth,
    Revenue,
    RevenueRank
FROM RankedCustomers
WHERE RevenueRank <= 10
ORDER BY OrderMonth,
         Revenue DESC;
