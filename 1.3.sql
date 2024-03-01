WITH HOUR_DETAILS AS (
    SELECT
        TO_CHAR(TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI'), 'HH AM') AS hourr,
        SUM(QUANTITY * PRICE) AS Total_Income,
        COUNT(*) AS number_of_invoices
    FROM tableRetail
    GROUP BY  TO_CHAR(TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI'), 'HH AM')
)

SELECT
    hourr,
    Total_Income,
    number_of_invoices,
    rank() OVER (ORDER BY Total_Income DESC) AS row_num
FROM HOUR_DETAILS;