select StockCode , FORMAT(product_sales, '#,###.##') product_sales ,rank() over(order by product_sales desc) as product_rnk

from (select distinct StockCode ,

round(sum(quantity * price) over(partition by StockCode)) as product_sales

from table_retail) x

order by product_rnk

limit 10;