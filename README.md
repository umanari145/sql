# sql

参考URL
http://www.geocities.jp/mickindex/database/db_support_sinan.html

参考書籍
達人に学ぶSQL徹底指南書

## 対象問題
- sample1.sql case文活用と自己結合
- sample2.sql 比較的複雑なSQL(サブテーブルの作成)
- sample3.sql HAVINGの活用
- sample4.sql 前年度との比較問題,EXISTSの活用
- sample5.sql NOT EXISTSなど

## セミナー用問題
- sql_seminar.sql セミナー用のDB構成のSQL文
- sql_seminar_question.sql セミナー用の問題
- sql_answer.sql セミナー用の解答SQL

## MySQL→PostgreSQLへの移行
`--compatible=postgresql`は全然万能ではない
移行時の注意
 - クオートいらない
 - 使用されない型(tinyintなど)に注意
 - 使用されない情報(unsgined)に注意
 - インデックスがそのまま移行できない

定義
```
mysqldump -uroot -p データベース名 --compatible=postgresql -d --skip-quote-names --skip-add-locks --default-character-set=utf8 > データベース定義.sql
```

データ
```
mysqldump -uroot -p データベース名 --compatible=postgresql -c -t --extended-insert --skip-quote-names --skip-add-locks --default-character-set=utf8 > データベースデータ.sql
```
