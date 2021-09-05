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
`--compatible=postgresql`は全然万能ではない<br>
移行時の注意
 - クオートいらない
 - 使用されない型(tinyintなど)に注意
 - 使用されない情報(unsgined)に注意
 - インデックスがそのまま移行できない

MySQLからダンプするとき定義を出して、手動で定義の修正後、データのインポートをするのがもっとも簡易

定義
```
mysqldump -uroot -p データベース名 --compatible=postgresql -d --skip-quote-names --skip-add-locks --default-character-set=utf8 > データベース定義.sql
```

データ
```
mysqldump -uroot -p データベース名 --compatible=postgresql -c -t --extended-insert --skip-quote-names --skip-add-locks --default-character-set=utf8 > データベースデータ.sql
```

同一環境にMySQLあればpgloaderが一番正確かも・・・<br>
https://pgloader.io/


## SQL SERVER

https://qiita.com/takanemu/items/be99c7445f5832f45064

```
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa

一般のSQL文;
go
までが一般的な流れ

show databases
1> select name from sys.databases
2> go

もともと入っているdb
master                                                                                                                  
tempdb                                                                                                                  
model                                                                                                                   
msdb 

db作成
1> create database sampledb
2> go

db選択
1> use sampledb
2> go

create table users(id int identity(1,1) primary key, name nvarchar(32), sex tinyint, birthday datetime);

型ワンポイントメモ
char→文字数固定。全角非推奨。
varchar→最大文字数固定（未満でもOK）。全角非推奨。
nchar→文字数固定。全角半角関係なし。
nvarchar→最大文字数固定（未満でもOK）。全角半角関係なし。


対象のテーブル一覧
SELECT * FROM INFORMATION_SCHEMA.tables
or 
select * from sys.objects where type = 'U'

MySQLの\Gのように綺麗に観れたりしないのがネック

insert
1> insert into users values ('taro', '1', '2020-03-01T00:00:00.000');
2> insert into users values ('hanako', '2', '2020-03-02');
3> insert into users values ('山田太郎', '1', '2020-03-03T01:23:45.678');
4> go
```