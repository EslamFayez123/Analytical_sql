WITH update_retail AS (
    SELECT  
        customer_id,
        Quantity,
        Price,
        Invoice,
        ROUND(MAX(TO_DATE(InvoiceDate, 'MM/DD/YYYY HH24:MI')) OVER () - MAX(TO_DATE(InvoiceDate, 'MM/DD/YYYY HH24:MI')) OVER (PARTITION BY customer_id)) AS recency
    FROM tableRetail
),
cte_2 AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT invoice) AS frequency,
        SUM(price * quantity) AS monetary,
        recency
    FROM update_retail 
    GROUP BY customer_id, recency
),
cte_3 AS (
    SELECT 
        customer_id,
        recency,
        frequency,
        NTILE(5) OVER (ORDER BY frequency ) AS F_score,
        monetary,
        ROUND(PERCENT_RANK() OVER (ORDER BY monetary ), 2) AS monetary_percent_rank
    FROM cte_2
),
cte_4 AS (
    SELECT 
        customer_id,
        recency,
        frequency,
        monetary,
        monetary_percent_rank,
        NTILE(5) OVER (ORDER BY recency DESC) AS R_score, 
        NTILE(5) OVER (ORDER BY (F_score + monetary_percent_rank) / 2) AS FM_score
    FROM cte_3
)
SELECT 
    customer_id,
    recency,
    frequency,
    monetary,
    R_score,
    FM_score,
    monetary_percent_rank,
    monetary / SUM(monetary) OVER () AS monetary_percentage,
    CASE
        WHEN R_score = 5 AND FM_score IN (5, 4) THEN 'champions'
        WHEN R_score = 4 AND FM_score = 5 THEN 'champions'
        WHEN R_score = 5 AND FM_score = 2 THEN 'potential loyalist'
        WHEN R_score = 4 AND FM_score IN (2 , 3) THEN 'potential loyalist'
        WHEN R_score = 3 AND FM_score = 3 THEN 'potential loyalist'
        WHEN R_score = 5 AND FM_score = 3 THEN 'loyal customers'
        WHEN R_score = 4 AND FM_score = 4 THEN 'loyal customers'
        WHEN R_score = 3 AND FM_score IN (5, 4) THEN 'loyal customers'
        WHEN R_score = 5 AND FM_score = 1 THEN 'recent customer'
        WHEN R_score = 4 AND FM_score = 1 THEN 'promising'
        WHEN R_score = 3 AND FM_score = 1 THEN 'promising'
        WHEN R_score = 2 AND FM_score IN (3, 2) THEN 'needs attention'
        WHEN R_score = 3 AND FM_score = 2 THEN 'needs attention'
        WHEN R_score = 2 AND FM_score IN (5, 4) THEN 'At Risk'
        WHEN R_score = 1 AND FM_score = 3 THEN 'At Risk'
        WHEN R_score = 1 AND FM_score IN (5, 4) THEN 'cant lose them'
        WHEN R_score = 1 AND FM_score = 2 THEN 'Hibernating'
        WHEN R_score = 1 AND FM_score = 1 THEN 'lost'
        ELSE 'About to sleep '
    END AS Customer_segmentation
FROM cte_4
ORDER BY customer_id;

