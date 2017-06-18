-- data read.mdのリンクの/* テーブル同士のマッチング */
--   goal
---  course_name | 2007年6月 | 2007年7月 | 2007年8月
--- -------------+-----------+-----------+-----------
---  経理入門    | 〇        | ×         | ×
---  財務知識    | ×         | ×         | 〇
---  簿記検定    | 〇        | ×         | ×
---  税理士      | 〇        | 〇        | 〇

SELECT
  coursemaster.course_name,
  ( CASE WHEN ( SELECT COUNT(*) as CNT FROM opencourses WHERE opencourses.course_id = coursemaster.course_id AND month ='200706') > 0 THEN '〇' ELSE '×' END ) AS "2007年6月",
  ( CASE WHEN ( SELECT COUNT(*) as CNT FROM opencourses WHERE opencourses.course_id = coursemaster.course_id AND month ='200707') > 0 THEN '〇' ELSE '×' END ) AS "2007年7月",
  ( CASE WHEN ( SELECT COUNT(*) as CNT FROM opencourses WHERE opencourses.course_id = coursemaster.course_id AND month ='200708') > 0 THEN '〇' ELSE '×' END ) AS "2007年8月"
FROM
  coursemaster

-- data read.mdのリンクの/* 演習問題2-2：地域ごとのランキング */
-- goal

---  district |  name  | price | rank
--- ----------+--------+-------+------
---  関西     | レモン |    70 |    1
---  関西     | スイカ |    30 |    2
---  関西     | りんご |    20 |    3
---  関東     | パイン |   100 |    1
---  関東     | レモン |   100 |    1
---  関東     | りんご |   100 |    1
---  関東     | ぶどう |    70 |    4
---  東北     | みかん |   100 |    1
---  東北     | りんご |    50 |    2
---  東北     | ぶどう |    50 |    2
---  東北     | レモン |    30 |    4

-- 集計関数利用

SELECT
  district ,
  name,
  price,
  RANK() OVER (PARTITION BY district ORDER BY price DESC)
FROM
  DistrictProducts

-- 自己流
-- 自己結合を使う　＆自分以外で自分より金額の低いものをcountする
SELECT
  d1.district ,
  d1.name,
  d1.price,
 ( SELECT
    COUNT(*) + 1
   FROM DistrictProducts d2
    WHERE
     d1.district = d2.district AND
     d1.name <> d2.name AND
     d1.price < d2.price
  ) AS rank
FROM
  DistrictProducts d1
ORDER BY
  d1.district,rank ASC
