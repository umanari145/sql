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

-- data read.mdのリンクの/* --時系列に歯抜けがある場合：直近と比較 */
-- goal
--  this_year | diff
-- -----------+------
--       1990 |
--       1992 | =
--       1993 | =
--       1994 | ↑
--       1997 | ↑


--step1 まずは直近年を取得する方法をつかむ

SELECT
  s1.year as this_year,
  MAX(s2.year) as compare_year
FROM
  sales2 s1 ,sales2 s2
WHERE
  s2.year < s1.year
GROUP BY
  s1.year

--step1 別解
SELECT
  s1.year as this_year,
  ( SELECT MAX(s2.year) FROM sales2 s2 WHERE s2.year < s1.year )  as compare_year_sale
FROM
  sales2 s1;

--step2 step1をもとに比較して出力
SELECT
  s1.year as this_year,
  s3.year as compare_year,
  s1.sale as this_sale,
  s3.sale as compare_sale
FROM
  sales2 s1,sales2 s3
WHERE
  s3.year = ( SELECT MAX(s2.year) FROM sales2 s2 WHERE s2.year < s1.year )

--step3 変化をつけて出力 最初の年(1990)はでない
SELECT
  s1.year as this_year,
  CASE
    WHEN s1.sale - s3.sale > 0 THEN '↑'
    WHEN s1.sale - s3.sale < 0 THEN '↓'
    WHEN s1.sale - s3.sale = 0 THEN '='
  ELSE NULL END AS diff
FROM
  sales2 s1,sales2 s3
WHERE
  s3.year =
   ( SELECT MAX(s2.year) FROM sales2 s2 WHERE s2.year < s1.year )

--別解 1990も出力 結合の利用(結合は別に被結合テーブルのカラムをくっつける必要はなく、
-- 単純にWHEREと同じ)
SELECT
  s1.year as this_year,
  CASE
    WHEN s1.sale - s3.sale > 0 THEN '↑'
    WHEN s1.sale - s3.sale < 0 THEN '↓'
    WHEN s1.sale - s3.sale = 0 THEN '='
  ELSE NULL END AS diff
FROM
  sales2 s1
LEFT JOIN
  sales s3
ON
  s3.year =
   ( SELECT MAX(s2.year) FROM sales2 s2 WHERE s2.year < s1.year )

-- data read.mdのリンクの/* 累計を求める */
-- goal
---   prc_date  | onhand_amt
--- ------------+------------
---  2006-10-26 |      12000
---  2006-10-28 |      14500
---  2006-10-31 |       -500
---  2006-11-03 |      33500
---  2006-11-04 |      28500
---  2006-11-06 |      35700
---  2006-11-11 |      46700

-- 分析関数を使う
SELECT
  prc_date ,
  SUM(prc_amt) OVER (ORDER BY prc_date ) AS onhand_amt
FROM accounts;

-- 生のSQL
SELECT
  a1.prc_date,
  ( SELECT SUM(a2.prc_amt) FROM accounts a2 WHERE a2.prc_date <= a1.prc_date) AS onhand_amt
FROM accounts a1;

-- data read.mdのリンクの/* 移動累計を求める */
-- goal
---   prc_date  | onhand_amt
--- ------------+------------
---  2006-10-26 |      12000
---  2006-10-28 |      14500
---  2006-10-31 |       -500
---  2006-11-03 |      21500
---  2006-11-04 |      14000
---  2006-11-06 |      36200
---  2006-11-11 |      13200

-- 分析関数
SELECT
  prc_date ,
  SUM(prc_amt) OVER (ORDER BY prc_date ROWS 2 PRECEDING) AS onhand_amt
FROM accounts;

--- 生のSQL
SELECT
  a1.prc_date,
  ( SELECT SUM(a2.prc_amt)
     FROM accounts a2
	WHERE a2.prc_date <= a1.prc_date
	 AND
	   --全く関係ないテーブルを1つ用意し、端店の間が3以内ということを示す
	   ( SELECT COUNT(*) FROM accounts a3 WHERE a3.prc_date BETWEEN a2.prc_date AND a1.prc_date ) <= 3  ) AS onhand_amt
FROM accounts a1;
