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