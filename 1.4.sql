WITH MonthSales AS (
    SELECT
        TO_CHAR(TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI'), 'DD') AS actual_date,
        TO_CHAR(TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI'), 'Mon YYYY') AS monthh,
        quantity,
        price
    FROM tableretail
),
avgg AS (
    SELECT
        monthh,
        SUM(CASE WHEN TO_NUMBER(actual_date) <= 10 THEN Price * Quantity ELSE 0 END) AS total_sales_of_first_10_days,
        SUM(CASE WHEN TO_NUMBER(actual_date) BETWEEN 11 AND 20 THEN Price * Quantity ELSE 0 END) AS total_sales_of_second_10_days,
        SUM(CASE WHEN TO_NUMBER(actual_date) BETWEEN 21 AND 31 THEN Price * Quantity ELSE 0 END) AS total_sales_of_third_10_days
    FROM MonthSales
    GROUP BY monthh
)
SELECT
    sum(total_sales_of_first_10_days) AS avg_10,
    sum(total_sales_of_second_10_days) AS avg_20,
    sum(total_sales_of_third_10_days) AS avg_30
FROM avgg;
