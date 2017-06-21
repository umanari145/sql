-- data read.mdのリンクの/* クロス表で入れ子の表側を作る */
--   goal
--  age_range | sex | 東北 | 関東
-- -----------+-----+------+------
--  21～30歳  | 男  | 1100 | 1800
--  21～30歳  | 女  | 1300 | 2500
--  31～40歳  | 男  |      |
--  31～40歳  | 女  |      |
--  41～50歳  | 男  | 1000 |
--  41～50歳  | 女  | 1800 | 2100


-- step1 年齢と性別だけのテーブル
SELECT
    t1.*
FROM
    (
        SELECT
            age.*,
            sex.*
        FROM
            tblage age,
            tblsex sex
    ) t1
ORDER BY
    t1.age_class ASC

-- step2-1  地区カラムの作成
SELECT
    pop.*,
    CASE
        WHEN pop.pref_name IN('秋田', '青森') THEN pop.population
        ELSE NULL
    END as 東北,
    CASE
        WHEN pop.pref_name IN('千葉', '東京') THEN pop.population
        ELSE NULL
    END as 関東
FROM
    tblpop pop

-- step2-2 年齢ごと、性別ごとの人口集計

SELECT
    pop.age_class,
    pop.sex_cd,
    SUM(CASE WHEN pop.pref_name IN('秋田', '青森') THEN pop.population ELSE NULL END) as 東北,
    SUM(CASE WHEN pop.pref_name IN('千葉', '東京') THEN pop.population ELSE NULL END) as 関東
FROM
    tblpop pop
GROUP BY
    pop.age_class,
    pop.sex_cd

-- ゴール
SELECT
    t1.age_range,
    t1.sex,
    pop2.東北,
    pop2.関東
FROM
    (
        SELECT
            age.*,
            sex.*
        FROM
            tblage age,
            tblsex sex
    ) t1
    LEFT JOIN
        (
            SELECT
                pop.age_class,
                pop.sex_cd,
                SUM(CASE WHEN pop.pref_name IN('秋田', '青森') THEN pop.population ELSE NULL END) as 東北,
                SUM(CASE WHEN pop.pref_name IN('千葉', '東京') THEN pop.population ELSE NULL END) as 関東
            FROM
                tblpop pop
            GROUP BY
                pop.age_class,
                pop.sex_cd
        ) pop2
    ON  t1.age_class = pop2.age_class
    AND t1.sex_cd = pop2.sex_cd
ORDER BY
    t1.age_class ASC