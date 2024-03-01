CREATE TABLE transactions (
    Cust_id VARCHAR2(200),
    "Date" DATE,
    Amount INT
);

WITH cte AS (
    SELECT
        Cust_Id,
        amount,
        "Date",
        "Date" - ROW_NUMBER() OVER (PARTITION BY Cust_Id ORDER BY "Date") AS grp
    FROM
        transactions
),max_cons_days as(
SELECT
    cust_id,
    amount,
    COUNT(grp) OVER (PARTITION BY  grp,cust_id) AS count_per_grp
FROM
    cte
    where amount > 0
    )
select max (count_per_grp) , cust_id
from max_cons_days
group by cust_id;

