

with cte as(
    SELECT TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI') AS INVOICEDATE,
           invoice,
           stockcode,
           quantity,
           price,
           customer_id,
           country
    FROM tableRetail)
    
SELECT 
       EXTRACT(MONTH FROM invoicedate) AS SalesMonth,
       SUM(quantity * price) AS TotalSales
FROM cte
GROUP BY EXTRACT(YEAR FROM INVOICEDATE), EXTRACT(MONTH FROM INVOICEDATE)
ORDER BY EXTRACT(YEAR FROM INVOICEDATE), EXTRACT(MONTH FROM INVOICEDATE);