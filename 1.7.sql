




WITH product_sales AS (
    SELECT Distinct
        stockcode,
        ROUND(SUM(quantity * price) OVER (PARTITION BY stockcode)) AS stock_sales
    FROM tableRetail
)
SELECT
    stockcode,
    stock_sales,
    RANK() OVER (ORDER BY stock_sales DESC) AS product_rnk
FROM product_sales
ORDER BY product_rnk;
