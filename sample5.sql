-- data read.mdのリンクの/*  差集合で関係除算を表現する */
--
--  emp
-- ------
--  神崎
--  相田

-- JOINとhavingで情報を抽出(最頻値問題の解答)
SELECT
  emp
FROM
  empskills es
INNER JOIN
  skills ss
ON
  es.skill = ss.skill
GROUP BY
  emp
HAVING COUNT(*) = ( SELECT COUNT(*) FROM skills)

--空集合の活用(参考書のp131の図がわかりやすい)
--step1 差分の獲得

--差がある
SELECT
  ss.skill
FROM
  skills ss
EXCEPT
SELECT
  es.skill
FROM
  empskills es
WHERE
  es.emp ='平井';

--差が全くない(抽出したいタイプのレコード)
SELECT
  ss.skill
FROM
  skills ss
EXCEPT
SELECT
  es.skill
FROM
  empskills es
WHERE
  es.emp ='相田';

--step2 差分がない=NOT EXISTSを使う
SELECT
  *
FROM
  empskills es
WHERE
  NOT EXISTS
  (
   SELECT
     skill
   FROM
     skills ss
   EXCEPT
     SELECT
       skill
     FROM
       empskills es2
     WHERE
        es.emp = es2.emp
  )

--step3 重複を除く
SELECT
  DISTINCT(es.emp)
FROM
  empskills es
WHERE
  NOT EXISTS
  (
   SELECT
     skill
   FROM
     skills ss
   EXCEPT
     SELECT
       skill
     FROM
       empskills es2
     WHERE
        es.emp = es2.emp
  );


-- data read.mdのリンクの等しい部分集合を見つける
--               s1_sup              |              s2_sup              | cnt
-- ----------------------------------+----------------------------------+-----
--  A                                | C                                |   3
--  B                                | D                                |   2
--  C                                | A                                |   3
--  D                                | B                                |   2

-- step1 自己結合し、共通した組み合わせをもつ(INNER JOINのほうがわかりやすいかも)
SELECT
  s1.sup as s1_sup,
  s2.sup as s2_sup,
  COUNT(*) as cnt
FROM
  supparts s1,supparts s2
WHERE
  s1.sup <> s2.sup AND s1.part = s2.part
GROUP BY
  s1_sup,s2_sup


--step2 countが自分(s1.sup)と同じ ⇒ 自分から見た場合に過不足がないと判断できる
--逆側(s2.sup)からみても過不足ないことが条件
--havingは全体だけではなく、一行単位での処理も当然できる
SELECT
  s1.sup as s1_sup,
  s2.sup as s2_sup,
  COUNT(*) as cnt
FROM
  supparts s1,supparts s2
WHERE
  --重複を外したい場合は s1.sup <> s2.supをs1.sup < s2.supにする
  s1.sup <> s2.sup AND s1.part = s2.part
GROUP BY
  s1_sup,s2_sup
HAVING
  COUNT(*) = ( SELECT COUNT(*) FROM supparts s3 WHERE s3.sup = s1.sup)
AND COUNT(*) = ( SELECT COUNT(*) FROM supparts s4 WHERE s4.sup = s2.sup)
ORDER BY
 s1_sup,s2_sup

-- 重複行の抽出
--  rowid
-- -------
--      3
--      2
SELECT
 p1.rowid
FROM
 products p1
EXCEPT (
-- name,priceで重複のない行
  SELECT
    MAX(p2.rowid)
  FROM
    products p2
  GROUP BY
    p2.name,p2.price
)






