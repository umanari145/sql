-- data read.mdのリンクの/* HAVING 句でサブクエリ：最頻値を求める(メジアンも同じサンプルを使用) */
--   goal
---  income | cnt
---  ------+-----
---  10000 |   3
---  20000 |   3

SELECT
    g.income,
    COUNT(*) as cnt
FROM
    graduates g
GROUP BY
    income
HAVING COUNT(*) = (
    SELECT
        MAX(t1.cnt2)
    FROM
        (
            SELECT
                income,
                COUNT(*) as cnt2
            FROM
                graduates
            GROUP BY
                income
        ) t1
)

-- data read.mdのリンクの/* 関係除算でバスケット解析 */
--   goal
-- shop | count
-- ------+-------
--  東京 |     3
--  仙台 |     3

SELECT
  shopitems.shop,
  count(*)
FROM
  items2
LEFT JOIN
  shopitems
ON
  items2.item = shopitems.item
GROUP BY
  shopitems.shop
HAVING COUNT(*)  = (SELECT COUNT(*) FROM items2);





