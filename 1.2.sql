
--time aspect
WITH MonthlySales AS (
    SELECT TO_DATE(INVOICEDATE,'MM/DD/YYYY HH24:MI') AS actual_date,
           quantity,
           price
    FROM tableretail
)
SELECT EXTRACT(YEAR FROM actual_date) AS year,
       EXTRACT(MONTH FROM actual_date) AS month,
       SUM(price * quantity) AS total_sales,
       LAG(SUM(price * quantity)) OVER (ORDER BY EXTRACT(YEAR FROM actual_date), EXTRACT(MONTH FROM actual_date)) AS prev_month_sales,
       (SUM(price * quantity) - LAG(SUM(price * quantity)) OVER (ORDER BY EXTRACT(YEAR FROM actual_date), EXTRACT(MONTH FROM actual_date))) / LAG(SUM(price * quantity)) OVER (ORDER BY EXTRACT(YEAR FROM actual_date), EXTRACT(MONTH FROM actual_date)) * 100 AS growth_rate,
       RANK() OVER(ORDER BY sum( QUANTITY * PRICE) DESC) AS MONTH_RANK
FROM MonthlySales
GROUP BY EXTRACT(YEAR FROM actual_date), EXTRACT(MONTH FROM actual_date)
ORDER BY EXTRACT(YEAR FROM actual_date), EXTRACT(MONTH FROM actual_date);
