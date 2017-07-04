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
ORDER BY
 s1_sup,s2_sup

