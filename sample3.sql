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

--data read.mdのリンクのメジアンを求めるSQL：自己非等値結合をHAVING句で使う(p.70)
-- goal
-- avg
-- 17500

-- step1 自分の順位(ただし通常の順位ではなく、重複があった場合は順位が下がる場合)を求める
--- 例 100,90,90,80,80,80があった場合は100が1,90が3,80が6

SELECT
  g1.income,
  (SELECT COUNT(*) FROM graduates g2  WHERE g2.income >= g1.income ) as order_inc_myself
FROM
  graduates g1;

--step2 逆側からももとめる
SELECT
  g1.income,
  (SELECT COUNT(*) FROM graduates g2  WHERE g2.income >= g1.income ) as order_inc_myself1,
  (SELECT COUNT(*) FROM graduates g3  WHERE g3.income <= g1.income ) as order_inc_myself2
FROM
  graduates g1;

--step3 order_incが中間のものを両サイドから挟んで総数が半分より上のものを取得する
--　イメージが難しいので達人に学ぶSQL指南書のP70の数字がいいかも
SELECT
  g1.income
FROM
  graduates g1
WHERE
  (SELECT COUNT(*) FROM graduates g2  WHERE g2.income >= g1.income ) >= ( SELECT COUNT(*)/2 FROM graduates ) AND
  (SELECT COUNT(*) FROM graduates g3  WHERE g3.income <= g1.income ) >= ( SELECT COUNT(*)/2 FROM graduates )

--step4 step3の結果を見ればわかるが重複を無視して平均をとる
SELECT
  AVG(distinct g1.income)
FROM
  graduates g1
WHERE
  (SELECT COUNT(*) FROM graduates g2  WHERE g2.income >= g1.income ) >= ( SELECT COUNT(*)/2 FROM graduates ) AND
  (SELECT COUNT(*) FROM graduates g3  WHERE g3.income <= g1.income ) >= ( SELECT COUNT(*)/2 FROM graduates )

