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

--別解(EXCEPTを使わずに)
SELECT
  es.emp
FROM
  EmpSkills es
INNER JOIN
  Skills s
ON
  es.skill = s.skill
GROUP BY
  es.emp
HAVING COUNT(*) = (SELECT COUNT(*) FROM Skills)

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

-- data テーブルに存在「しない」データを探す
-- +-----------+--------+
-- | meeting   | person |
-- +-----------+--------+
-- | 第１回    | 宮田   |
-- | 第２回    | 坂東   |
-- | 第２回    | 水島   |
-- | 第３回    | 伊藤   |
-- +-----------+--------+

-- step1-1 まずは皆勤テーブルをつくる(これが難しい!)
-- まずは直積で全組み合わせを作る
SELECT
  M1.meeting, M2.person
FROM
  Meetings M1,Meetings M2
ORDER BY
  M1.meeting, M2.person

--step1-2 その中で回数とM2の人間でDISTINTで重複を避ける
-- 全結合テーブルをみないとなぜM1.meetingとM2.personをとるのかがイメージしにくい
SELECT
  DISTINCT M1.meeting, M2.person
FROM
  Meetings M1,Meetings M2
ORDER BY
  M1.meeting, M2.person

-- data 肯定⇔二重否定の変換に慣れよう
-- +------------+
-- | student_id |
-- +------------+
-- |        100 |
-- |        200 |
-- |        400 |
-- +------------+

-- 全教科50点以上 => NOT EXISTS 50点以下
SELECT
 DISTINCT ts1.student_id
FROM
 TestScores ts1
WHERE
 NOT EXISTS (
   SELECT * FROM  TestScores ts2 WHERE ts1.student_id = ts2.student_id AND ts2.score < 50
 )


--算数が80以上かつ国語が50以上
-- +------------+
-- | student_id |
-- +------------+
-- |        100 |
-- |        200 |
-- +------------+

SELECT
  tbl_1.student_id
FROM
(
  SELECT
    ts1.student_id,
    CASE WHEN
      ( ts1.subject = '国語' and ts1.score >= 50 ) or
      ( ts1.subject = '算数' and ts1.score >= 80 )
    THEN 1 ELSE 0 END as score_div
    FROM TestScores ts1
) tbl_1
GROUP BY tbl_1.student_id
HAVING SUM(tbl_1.score_div) = 2


--3人以上座れる積
--goal
-- +------------+-----------+
-- | first_seat | last_seat |
-- +------------+-----------+
-- |          3 |         5 |
-- |          7 |         9 |
-- |          8 |        10 |
-- |          9 |        11 |
-- +------------+-----------+

--step1 まずは自己結合にて始点と終点を決める
SELECT
 s1.seat AS first_seat,
 s1.status AS first_status,
 s2.seat AS last_seat,
 s2.status AS last_statues
FROM
 Seats s1, Seats s2
WHERE
  s2.seat = s1.seat + 2

--step2 空のレコードがあいだに存在していない条件を追加
SELECT
 s1.seat AS first_seat,
 s2.seat AS last_seat
FROM
 Seats s1, Seats s2
WHERE
  s2.seat = s1.seat + 2
AND
  NOT EXISTS ( SELECT * FROM Seats s3 WHERE s3.seat BETWEEN s1.seat AND s2.seat AND s3.status = '占');
