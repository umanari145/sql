/** 3-1-1 caseによる条件分岐 **/
SELECT 
  user_id,
  CASE 
    register_device 
      WHEN '1' THEN 'PC' /** case when register_device = 1 then 'pc' でも　OK **/
      WHEN '2' THEN 'SP'
      WHEN '3' THEN 'アプリ'
      ELSE NULL 
  END AS device_name
FROM 
  mst_users;


/** 3-1-2 正規表現を使った置換処理 hostの抽出**/
SELECT 
  stamp,
  referrer,
  /** 通常の正規表現と一緒 \1は()の1番目という意味　**/
  regexp_replace(referrer, '(http)(s*)://(.*?)/(.*)', '\3') AS referrer_host
FROM
 access_log; 


SELECT 
  stamp,
  referrer,
  /** 通常の正規表現と一緒 \1は()の1番目という意味　**/
  regexp_replace(referrer, '(http)(s*)://(.*?)/(.*)', '\3') AS referrer_host
FROM
 access_log;


SELECT 
  stamp,
  url,
  /** pathはドメインとクエリ以下の箇所 **/
  regexp_replace(url, '(http)(s*)://(.*?)/(.*)([\?#])(.*)', '\4') AS path,
  /** id=() の部分を抽出 []が人グループ、|がorを表す**/
  regexp_replace(url, '(http)(s*)://(.*?)/(.*)([\?#])([id=]*|ref*)(.*)', '\7') AS id
FROM
 access_log;

/** substringでの抽出 urlでドメイン以下のパスをクエリ部分を抜いて(←ここを^で表現)抽出 ()部分が出力される部分**/
/** split_part はPHPでいうexplodeとそのいくつ目みたいなイメージ **/
 SELECT 
  stamp,
  url,
  substring(url ,'//[^/]*/([^?#]*)') AS path0,
  split_part(substring(url, '//[^/]+([^?#]+)'), '/', 2) AS path1,
  split_part(substring(url, '//[^/]+([^?#]+)'), '/', 3) AS path2
FROM
 access_log;

/** 以下の処理はtimestamp型でないと使えない **/
SELECT 
  stamp,
  extract(YEAR FROM stamp) AS YEAR,
  extract(MONTH FROM stamp) AS month,
  extract(DAY FROM stamp) AS DAY
FROM
 (SELECT cast('2016-01-31' AS timestamp) AS stamp) AS t;

/** 通常の文字の場合は以下のようにsubstringを使えばOK **/
SELECT 
  stamp,
  substr(stamp,1,4) AS YEAR
FROM
  access_log;

/** coalesceはMySQLのIFnullに近い **/
SELECT 
  amount,
  coupon,
  amount - coupon AS discount,
  amount - coalesce(coupon,0) AS discount2
FROM
  purchase_log_with_coupon

/** 差分の可視化 singは0より大きい、0と同じ、0より小さいの判定 **/
SELECT 
  year,
  q2-q1 AS q2_q1_diff,
  CASE 
    WHEN q2 - q1 > 0 THEN '+'
    WHEN q2 - q1 = 0 THEN '='
    WHEN q2 - q1 < 0 THEN '-'
  END AS judge_q2_q1,
  sign(q2-q1)  AS sign_q2_q1
FROM 
  quarterly_sales

/** greatest(least)は横軸でMAX(MIN)の値を取得できる**/
SELECT
  year,
  q1,
  q2,
  q3,
  q4,
  greatest(q1,q2,q3,q4) AS max_sales,
  least(q1,q2,q3,q4) AS min_sales
FROM 
  quarterly_sales 