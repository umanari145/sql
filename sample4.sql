-- data read.mdのリンクの/* --成長・後退・現状維持 */
--   goal
---  this_year | this_year_sale | compare
--- -----------+----------------+---------
---       1990 |             50 | -
---       1991 |             51 | ↑
---       1992 |             52 | ↑
---       1993 |             52 | =
---       1994 |             50 | ↓
---       1995 |             50 | =
---       1996 |             49 | ↓
---       1997 |             55 | ↑

--step1 まずは今年度と昨年度の比較を取る

SELECT
  this_year.year as this_year,
  this_year.sale as this_year_sale,
  ( SELECT last_year.sale FROM sales last_year WHERE last_year.year +1 = this_year.year ) as last_year_sales
FROM
  sales this_year

--step2 CASE文の中で条件分岐

SELECT
  this_year.year as this_year,
  this_year.sale as this_year_sale,
  CASE WHEN ( this_year.sale - ( SELECT last_year.sale FROM sales last_year WHERE last_year.year +1 = this_year.year )) > 0 THEN '↑'
       WHEN ( this_year.sale - ( SELECT last_year.sale FROM sales last_year WHERE last_year.year +1 = this_year.year )) < 0 THEN '↓'
	   WHEN ( this_year.sale - ( SELECT last_year.sale FROM sales last_year WHERE last_year.year +1 = this_year.year )) = 0 THEN '='
	   ELSE '-' END as compare
FROM
  sales this_year

-- 別解(自己結合を使う。最初の年は現れない)
SELECT
  this_year.year as this_year,
  this_year.sale as this_sale,
  CASE
    WHEN (this_year.sale > last_year.sale) THEN '↑'
    WHEN (this_year.sale < last_year.sale) THEN '↓'
    WHEN (this_year.sale = last_year.sale) THEN '='
  ELSE NULL END as compare
FROM
  sales this_year,sales last_year
WHERE
  this_year.year = last_year.year + 1
