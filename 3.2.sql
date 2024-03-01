WITH cte_1 AS (
    SELECT
        cust_id,
        "Date",
        amount,
        SUM(amount) OVER (PARTITION BY cust_id ORDER BY "Date") AS total_amount
    FROM transactions
),
cte_2 AS (
    SELECT
        cust_id,
        "Date",
        amount,
        total_amount,
        CASE WHEN total_amount >= 250 THEN 1 ELSE 0 END AS reached_threshold
    FROM cte_1
    WHERE total_amount > 250
),
cte_3 AS (
    SELECT
        cust_id,
        "Date",
        amount,
        total_amount,
        CASE WHEN total_amount < 250 THEN 1 ELSE 0 END AS before_reached_threshold
    FROM cte_1
    WHERE total_amount <= 250
),
final AS (
    SELECT
        c.cust_id,
        COUNT(c.before_reached_threshold) AS before_reaching_threshold
    FROM cte_3 c
    WHERE c.cust_id IN (SELECT cust_id FROM cte_2)
    GROUP BY c.cust_id
)
SELECT
    AVG(before_reaching_threshold) AS avg_before_reaching_threshold
FROM final;
