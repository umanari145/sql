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