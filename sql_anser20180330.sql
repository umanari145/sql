サブクエリ & EXISTS
1-1 １回の注文が3000円以上の購入者のリスト(customer_id)を出力
SELECT
 ors.customer_id
FROM
  orders ors
WHERE
 (
  SELECT
    SUM(oi.total)
  FROM
    order_item oi
  WHERE
    oi.order_id = ors.order_id
 ) >= 3000;

 1-2 ヘッドと明細とで検索句を取りたい場合
 SELECT
  ors.*
 FROM
   orders ors
 WHERE
  EXISTS
  (
   SELECT
     order_item_id
   FROM
     order_item oi
   WHERE
     oi.order_id = ors.order_id
   AND
     oi.item_id = 13
   )

 1-3 未納データ
  SELECT
   DISTINCT t1.customer_id
  FROM
   tainousha t1
  WHERE
   NOT EXISTS
   (
     SELECT
       *
     FROM
       tainousha t2
     WHERE
         t2.customer_id = t1.customer_id
       AND
        t2.invoice_month BETWEEN  '2017-06-01' AND '2017-08-01'
       AND
       t2.payment_status = 10
   );

 1-4 ランク重複を含んだ処理
 SELECT
  p1.name,
  p1.price,
 (
   SELECT
    COUNT(p2.name)
   FROM
    products p2
  WHERE
   p2.price > p1.price
 )+1 AS order_rank
 FROM products p1
 ORDER BY order_rank

 *Postgres window関数使用
SELECT
 name,
 price,
 RANK() OVER ( ORDER BY price DESC ) AS rank1,
 DENSE_RANK() OVER ( ORDER BY price DESC ) AS rank2
FROM
 products;

2-1 総当たりを求めよ
自分を含んだ総当たり
SELECT
 b1.team as myself,
 b2.team as opponet
FROM
 baseball b1, baseball b2

自分を除いてorderbyをかける forのなかのifのような感じ
  SELECT
   b1.team as myself,
   b2.team as opponet
  FROM
   baseball b1, baseball b2
  WHERE
   b1.team <> b2.team
  ORDER BY
   b1.team

(下記と同じ)
  SELECT
    b1.team as myself,
    b2.team as opponent
  FROM
    baseball b1
  CROSS JOIN
    baseball b2
  ON
    b1.team <> b2.team
  ORDER BY
   b1.team
  * onに下記のようにかくと重複を防げる
   b1.team <> b2.team and b1.team > b2.team


2-2 前年売り上げとの比較をせよ
 //総当たり
 SELECT
  sa.year as this_year,
  sa.sale as this_sale,
  sb.year as comp_year,
  sb.sale as comp_sale
 FROM
  sales sa,sales sb
 ORDER BY
  this_year

 //この中で自分の年-1を取得
 SELECT
  sa.year as this_year,
  sa.sale as this_sale,
  sb.year as comp_year,
  sb.sale as comp_sale
 FROM
  sales sa,sales sb
 WHERE
  sa.year- 1 = sb.year
 ORDER BY
  this_year

 (1900年もでる)
  SELECT
   sa.year as this_year,
   sa.sale as this_sale,
   sb.year as comp_year,
   sb.sale as comp_sale
  FROM
   sales sa
  LEFT JOIN
   sales sb
  ON
   sa.year- 1 = sb.year
  ORDER BY
   this_year

2-3　集計表
SELECT
 age.age_range,
 sex.sex
FROM
 tblAge age ,tblSex sex
ORDER BY
 age.age_range

SELECT
 age.age_range,
 sex.sex
FROM
 tblAge age
CROSS JOIN
 tblSex sex
ORDER BY
 age.age_range

結合
https://qiita.com/Yinaura/items/3ab6fc49ae55f52e2d55
http://nullnote.com/programs/mysql/join/

3-1
都市問題
SELECT
  pref,
  population,
  CASE
    WHEN  population  <  100 THEN '小都市'
    WHEN  population  >=  100  and  population  < 500  THEN  '中都市'
    WHEN  population >=  500 THEN  '大都市'
  ELSE NULL END AS city_rank
FROM population;


SELECT
  CASE
  WHEN  population  <  100 THEN '小都市'
  WHEN  population  >=  100  and  population  < 500  THEN  '中都市'
  WHEN  population >=  500 THEN  '大都市'
  ELSE NULL END AS city_rank,
  count(*) as cnt
FROM population
GROUP BY city_rank;

3-2
講座開設
SELECT
 course_name ,
 (SELECT COUNT(oc.course_id) FROM openCourses oc WHERE oc.month='200706' AND oc.course_id =cm.course_id) AS "200706",
 (SELECT COUNT(oc.course_id) FROM openCourses oc WHERE oc.month='200707' AND oc.course_id =cm.course_id) AS "200707",
 (SELECT COUNT(oc.course_id) FROM openCourses oc WHERE oc.month='200708' AND oc.course_id =cm.course_id) AS "200708"
FROM
 courseMaster cm

CASE式で○×
SELECT
 course_name ,
 (CASE WHEN (SELECT COUNT(oc.course_id) FROM openCourses oc WHERE oc.month='200706' AND oc.course_id =cm.course_id) = 1 THEN '○' ELSE '-' END )AS "200706",
 (CASE WHEN (SELECT COUNT(oc.course_id) FROM openCourses oc WHERE oc.month='200707' AND oc.course_id =cm.course_id) = 1 THEN '○' ELSE '-' END )AS "200707",
 (CASE WHEN (SELECT COUNT(oc.course_id) FROM openCourses oc WHERE oc.month='200708' AND oc.course_id =cm.course_id) = 1 THEN '○' ELSE '-' END )AS "200708"
FROM
 courseMaster cm

3-3
SELECT
 sa.year as this_year,
 CASE
   WHEN sa.sale - sb.sale > 0 THEN '↑'
   WHEN sa.sale - sb.sale = 0 THEN '='
   WHEN sa.sale - sb.sale < 0 THEN '↓'
 ELSE '-' END  as diff
FROM
 sales sa
LEFT JOIN
 sales sb
ON
 sa.year- 1 = sb.year
ORDER BY
 this_year

4 having基礎　三人以上のクラスは
whereとの違い
GROUP BYで絞った後の抽出
https://dev.classmethod.jp/server-side/db/difference-where-and-having/
4-1
SELECT
 class,
 COUNT(*)
FROM
 students
GROUP BY
 class
HAVING COUNT(*) >= 3

4-2 商品を全て含む
SELECT
 si.shop,
 si.item as shop_item,
 i.item as item
FROM
 shopItems si
LEFT JOIN
 items i
ON
 si.item = i.item

 SELECT
  si.shop
 FROM
  shopItems si
 LEFT JOIN
  items i
 ON
  si.item = i.item
 GROUP BY
  si.shop
 HAVING COUNT(i.item)  >= (SELECT COUNT(i2.item) FROM items i2)

4-3 点数問題
EXISTSのみ
SELECT
 DISTINCT(ts1.student_id)
FROM
 testScores ts1
WHERE
 EXISTS ( SELECT  * FROM  testScores ts2 WHERE ts2.student_id = ts1.student_id AND  ts2.subject="国語" and ts2.score >= 80)
 AND EXISTS ( SELECT  * FROM  testScores ts3 WHERE ts3.student_id = ts1.student_id AND  ts3.subject="算数" and ts3.score >= 50)

 havingのみ(わかりやすくSUMをSELECT句に出す)
 SELECT
  ts1.student_id,
 SUM( ( CASE WHEN ts1.subject = '国語' and ts1.score >= 80 THEN 1 ELSE 0 END )) AS pass_1 ,
 SUM( ( CASE WHEN ts1.subject = '算数' and ts1.score >= 50 THEN 1 ELSE 0 END )) AS pass_2
 FROM
  testScores ts1
 GROUP BY
  ts1.student_id
 HAVING pass_1 = 1 AND pass_2 = 1



まずは性別、年齢テーブル
 SELECT
  age.age_class,
  age.age_range,
  sex.sex_cd,
  sex.sex
 FROM
  tblAge age ,tblSex sex
(  tblAge age CROSS JOIN tblSex sex )
 ORDER BY
  age.age_range

 人口テーブルと結合
  SELECT
   pop.pref_name,
   T1.*,
   pop.population
  FROM (
   SELECT
    age.age_class,
    age.age_range,
    sex.sex_cd,
    sex.sex
   FROM
    tblAge age ,tblSex sex
   ORDER BY
    age.age_range ) T1
  LEFT JOIN
   tblPop pop
  ON
   T1.age_class = pop.age_class AND
   T1.sex_cd = pop.sex_cd

   地区別人口分類
   SELECT
    pop.pref_name,
    T1.*,
    pop.population,
    CASE WHEN pref_name IN ('千葉','東京') THEN pop.population ELSE 0 END AS '関東',
    CASE WHEN pref_name IN ('秋田','青森') THEN pop.population ELSE 0 END AS '東北'
   FROM (
   SELECT
    age.age_class,
    age.age_range,
    sex.sex_cd,
    sex.sex
   FROM
    tblAge age ,tblSex sex
   ORDER BY
    age.age_range ) T1
   LEFT JOIN
    tblPop pop
   ON
    T1.age_class = pop.age_class AND
    T1.sex_cd = pop.sex_cd

 最終形
SELECT
 T1.age_range,
 T1.sex,
 SUM( CASE WHEN pref_name IN ('秋田','青森') THEN pop.population ELSE 0 END ) AS '東北',
 SUM( CASE WHEN pref_name IN ('千葉','東京') THEN pop.population ELSE 0 END ) AS '関東'
FROM (
 SELECT
  age.age_class,
  age.age_range,
  sex.sex_cd,
  sex.sex
 FROM
  tblAge age ,tblSex sex
 ORDER BY
  age.age_range ) T1
 LEFT JOIN
  tblPop pop
 ON
  T1.age_class = pop.age_class AND
  T1.sex_cd = pop.sex_cd
 GROUP BY T1.age_class, T1.sex_cd DESC


 高速化のコツ
 1.問題点の発見(slow_query_logや直書きでの測定、フレームワークのデバッガなど)
 2.主な対策
   2-1 SQL自体を減らす、改善する
     キャッシュの活用する
     ぐるぐる系→ガツン系へ
     SELECT句で*を使わない→カラム数が特に多いものに注意。メモリへの負担を考える
   2-2 インデックスを貼る
     EXPLAINによる解析→ボトルネックの発見
     ・rowsの数を少なくする
     ・select_typeがALLかindexになっているものがボトルネック→indexを貼る
     indexが効かないポイント
     　データが少ないケース(数千程度)
      like検索の中間一致、後方一致、否定形、is null、OR、暗黙の型変換(数値を文字列のように扱う)

Nested Loopに関して
https://qiita.com/yuku_t/items/208be188eef17699c7a5

//ボトルネックの検索EXPLAIN
alter table customers add index zip(zip);
alter table postcode add index zip(zip);

alter table customers drop index zip;
alter table postcode drop index zip;

130~150ms → 1~0.5ms
SELECT
  *
FROM
  customers c
LEFT JOIN
  postcode p
ON
 c.zip = p.zip;
