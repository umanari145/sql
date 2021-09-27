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

/** coalesceはMySQLのIFnullに近い(複数の値を取れる) **/
/** https://www.wakuwakubank.com/posts/786-mysql-null-ifnull-coalesce/ **/
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


SELECT 
  dt,
  ad_id,
  clicks,
  impressions,
  /** 小数点以下が無視される **/
  clicks  / impressions AS ctr0 ,
  /** 小数点にcastをする **/
  cast(clicks AS DOUBLE precision) / impressions AS ctr1,
  /** 数値をかけると自動的に変換される **/
  100.0 * clicks / impressions AS ctr2
FROM
  advertising_stats
WHERE
  dt = '2017-04-01'

SELECT 
  x1,
  x2,
  /** 絶対値 **/ 
  ABS(x2-x1) AS ABS,
  /** 塁上 **/ 
  power(x1-x2, 2) AS POWER
FROM
  location_1d

SELECT 
  x1,
  x2,
  y1,
  y2,
  /** ３平方の定理の活用 **/
  sqrt(POWER(x2-x1,2) + POWER(y2-y1,2)) AS distance1,
  /** postgresのみで使える手法 **/
  point(x1,y1) <-> point(x2,y2) AS distance2
FROM
  location_2d

SELECT 
  *,
  /** 文字列を時間(timestamp)に変換し、追加処理 **/
  register_stamp::TIMESTAMP + '1 hour'::INTERVAL AS after_1hours_str,
  /** 元々のtimestampはそのまま追加できる **/
  register_stamp_ts + '1 hour'::INTERVAL AS after_1hours,
  register_stamp_ts - '30 minutes'::INTERVAL AS before_30hours
FROM 
  mst_users_with_birthday

SELECT 
  *,
  /** 文字列を時間(timestamp)に変換し、追加処理 **/
  register_stamp::TIMESTAMP + '1 hour'::INTERVAL AS after_1hours_str,
  /** 元々のtimestampはそのまま追加できる **/
  register_stamp_ts + '1 hour'::INTERVAL AS after_1hours,
  register_stamp_ts - '30 minutes'::INTERVAL AS before_30hours,
  birth_date_ts + '1 day'::INTERVAL AS after_1days_ts,
  (birth_date_ts + '1 day'::INTERVAL)::DATE AS after_1days_dt
FROM 
  mst_users_with_birthday


 SELECT
  user_id,
  COUNT(product_id) AS cnt,
  AVG(score) AS AVG
FROM
  review
GROUP BY
  user_id

/** https://qiita.com/tlokweng/items/fc13dc30cc1aa28231c5  **/
/** 順位づけ **/
SELECT
  *,
  /** count(*)は書かなくても成立しそうな気もするが書かないと構文エラーになるため **/
  count(*) over(ORDER BY score desc) AS score_rank,
  /** カテゴリーごとのスコアランキングを出力 **/
  count(*) OVER(PARTITION by category ORDER BY score DESC ) AS score_rank_by_category
FROM 
  popular_products


/** categoryごとのランキングで二位まで抽出 **/
SELECT 
  product_id,
  category,
  score,
  score_rank_by_category
FROM (
  SELECT
    *,
    /** count(*)は書かなくても成立しそうな気もするが書かないと構文エラーになるため **/
    count(*) over(ORDER BY score desc) AS score_rank,
    /** カテゴリーごとのスコアランキングを出力 **/
    count(*) OVER(PARTITION by category ORDER BY score DESC ) AS score_rank_by_category
  FROM 
    popular_products
) pt
WHERE
  score_rank_by_category <= 2


/** MAXは最大値というよりは↓のケースでは値そのものを出力する意味合いが強い **/
SELECT
  dt,
  MAX(CASE WHEN INDICATOR = 'impressions' THEN val END) AS impressions,
  MAX(CASE WHEN INDICATOR = 'sessions' THEN val END) AS sessions,
  MAX(CASE WHEN INDICATOR = 'users' THEN val END) AS users
FROM 
  daily_kpi
GROUP BY
  dt

/** groupの中の物をカンマで結合 **/
SELECT
  purchase_id,
  string_agg(product_id, ',') AS concat_product_id
FROM 
  purchase_detail_log
GROUP BY
  purchase_id

SELECT
  *  
FROM 
  quarterly_sales
CROSS JOIN
  ( SELECT 1 AS idx ) pt1