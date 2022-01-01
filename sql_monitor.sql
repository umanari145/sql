-- 現在発行されているSQLを見る方法 SQLServer向け
SELECT TOP 100
     der.session_id as spid
    ,der.blocking_session_id as blk_spid
    ,datediff(s, der.start_time, GETDATE()) as elapsed_sec
    ,DB_NAME(der.database_id) AS db_name
    ,des.host_name
    ,des.program_name
    ,der.status -- Status of the request. (background / running / runnable / sleeping / suspended)
    ,dest.text as command_text
    ,REPLACE(REPLACE(REPLACE(SUBSTRING(dest.text, 
    (der.statement_start_offset / 2) + 1, 
    ((CASE der.statement_end_offset
    WHEN -1 THEN DATALENGTH(dest.text)
    ELSE der.statement_end_offset
    END - der.statement_start_offset) / 2) + 1),CHAR(13), ' '), CHAR(10), ' '), CHAR(9), ' ') AS current_running_stmt
    ,datediff(s, der.start_time, GETDATE()) as time_sec
    ,wait_resource --ロックされているリソース名
    ,wait_type
    ,last_wait_type --最後または現在の待機の種類の名前
    ,der.wait_time  as wait_time_ms
    ,der.open_transaction_count
    ,der.command
    ,der.percent_complete
    ,der.cpu_time
    ,(case der.transaction_isolation_level
      when 0 then 'Unspecified'
      when 1 then 'ReadUncomitted'
      when 2 then 'ReadCommitted'
      when 3 then 'Repeatable'
      when 4 then 'Serializable'
      when 5 then 'Snapshot'
    else cast(der.transaction_isolation_level as varchar) end) as transaction_isolation_level
    ,der.granted_query_memory * 8 as granted_query_memory_kb --キロバイト単位
    ,deqp.query_plan -- 実行プラン
FROM
    sys.dm_exec_requests der
JOIN sys.dm_exec_sessions des ON des.session_id = der.session_id
OUTER APPLY sys.dm_exec_sql_text(sql_handle) AS dest
OUTER APPLY sys.dm_exec_query_plan(plan_handle) AS deqp
WHERE
    des.is_user_process = 1
AND datediff(s, der.start_time, GETDATE()) >= 1 -- 例：1秒以上実行中のクエリに限定
AND dest.text like '%%' -- クエリの中身でlike検索したいときはここを編集
ORDER BY
    datediff(s, der.start_time, GETDATE()) DESC

-- コネクション判定
SELECT DB_NAME(sP.dbid) AS the_database
  , COUNT(sP.spid) AS total_database_connections
FROM sys.sysprocesses sP
GROUP BY DB_NAME(sP.dbid)
ORDER BY 1;

-- 負荷の高い累積SQLを見る方法
SELECT
    TOP 50 --上位50件
    [dm_exec_query_stats].[total_worker_time] / [dm_exec_query_stats].[execution_count] / 1000 AS [平均CPU時間(ミリ秒)],
    [dm_exec_query_stats].[max_worker_time] /1000 AS [最大CPU時間(ミリ秒)],  
    [dm_exec_query_stats].[total_worker_time] / 1000 AS [合計CPU時間(ミリ秒)],
    [dm_exec_query_stats].[total_logical_reads] / [dm_exec_query_stats].[execution_count] AS [平均読取数],
    [dm_exec_query_stats].[max_logical_reads] AS [最大読取数],  
    [dm_exec_query_stats].[total_logical_reads] AS [合計読取数],
    [dm_exec_query_stats].[last_execution_time] AS [最終実行時刻],
    [dm_exec_query_stats].[execution_count] AS [実行回数],
    [dm_exec_sql_text].[text] AS [SQL(コメントあり)]
 
FROM
    [sys].[dm_exec_query_stats] [dm_exec_query_stats]
    CROSS APPLY [master].[sys].[dm_exec_sql_text]([dm_exec_query_stats].[sql_handle]) [dm_exec_sql_text]
 
WHERE
    [dm_exec_sql_text].[text] NOT LIKE '%dm_exec_query_stats%' --本クエリを結果から取り除く。
 
ORDER BY
    [dm_exec_query_stats].[total_worker_time] / [dm_exec_query_stats].[execution_count] DESC --一回あたりのCPU時間が長い順に並べ替える。
;