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