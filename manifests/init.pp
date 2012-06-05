################################################################################
#
# This module manages the mysql 5.1 or 5.5 service.
#
#   Tested platforms:
#    - Ubuntu 12.04 Precise Pangolin
#    - Ubuntu 11.10 Oneiric
#    - Ubuntu 11.04 Natty
#    - Ubuntu 10.04 Lucid
#
# == Parameters
# 
# [+lastversion+]
#   (OPTIONAL) (default: false) 
#   
#   this variable allow to chose if the package should always be updated to the last available version (true) or not (false) (default: false)
#
# [+data_dir+]
#   (OPTIONAL) (default: $mysql::params::standard_db_data_dir) 
#   
#   this variable allow to choose where the database data will be installed.
#
# [+max_connections+]
#   (OPTIONAL) (default: 64) 
#   
#   this variable allow to chose the maximum connections on the database
#
# [+max_user_connections+]
#   (OPTIONAL) (default: 0) 
#   
#   this variable allow to chose the maximum connections per account (>0) or not (0)
#
# [+bind_address+]
#   (OPTIONAL) (default: 127.0.0.1) 
#   
#   this variable allow to define on which addresse to bind mysql
#
# [+port+]
#   (OPTIONAL) (default: 3306) 
#   
#   this variable allow to define the port for mysql connection
#
# [+temp_dir+]
#   (OPTIONAL) (default: depends on the OS) 
#   
#   this variable allow to change the directory used by mysql for temp data
#
# [+sock_path+]
#   (OPTIONAL) (default: depends on the OS) 
#   
#   this variable allow to change the location for the mysql socket file 
#
# [+default_storage_engine+]
#   (OPTIONAL) (default: INNODB) 
#   
#   this variable allow to change the default storage engine ( [ INNODB | MYISAMÊ] )  
#
# [+innodb_file_per_table+]
#   (OPTIONAL) (default: true) 
#   
#   this variable allow to InnoDB with 1 file per table (true) or not (false).
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_file_per_table
#
# [+innodb_buffer_pool_size+]
#   (OPTIONAL) (default: 128M) 
#   
#   this variable allow to configure the mysql innodb_buffer_pool_size parameter.
#   The parameter may be set to up to 80% of the machine physical memory size. 
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_buffer_pool_size
#   * http://www.mysqlperformanceblog.com/2007/11/03/choosing-innodb_buffer_pool_size 
#
# [+innodb_additional_mem_pool_size+]
#   (OPTIONAL) (default: 8M) 
#   
#   this variable allow to configure the mysql innodb_additional_mem_pool_size parameter.
#   The size in bytes of a memory pool InnoDB uses to store data dictionary information and other internal data structures. 
#   The more tables you have in your application, the more memory you need to allocate here. 
#   If InnoDB runs out of memory in this pool, it starts to allocate memory from the operating system and writes warning messages to the MySQL error log.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_additional_mem_pool_size
#
# [+innodb_thread_concurrency+]
#   (OPTIONAL) (default: 8) 
#   
#   this variable allow to configure the mysql innodb_thread_concurrency parameter.
#   this parameter should be set to 0 for a database dedicated server
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_thread_concurrency
#
# [+innodb_flush_method+]
#   (OPTIONAL) (default: O_DIRECT) 
#   
#   this variable allow to configure the mysql innodb_flush_method parameter.
#   this parameter should be set to :
#   * O_DIRECT to avoid double buffering between the InnoDB buffer pool and the operating system local filesystem cache.
#   * O_DSYNC for SAN filesystem
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_flush_method
#
# [+innodb_flush_log_at_trx_commit+]
#   (OPTIONAL) (default: 1 = ACID compliance) 
#   
#   this variable allow to configure the mysql innodb_flush_log_at_trx_commit parameter.
#   The default value of 1 is the value required for ACID compliance
#   this parameter should be set to :
#   * 0 => the log buffer is written out to the log file once per second and the flush to disk operation is performed on the log file, but nothing is done at a transaction commit. 
#   * 1 => the log buffer is written out to the log file at each transaction commit and the flush to disk operation is performed on the log file.
#   * 2 => the log buffer is written out to the file at each commit, but the flush to disk operation is not performed on it. However, the flushing on the log file takes place once per second also when the value is 2. Note that the once-per-second flushing is not 100% guaranteed to happen every second, due to process scheduling issues.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit
#
# [+innodb_lock_wait_timeout+]
#   (OPTIONAL) (default: 50) 
#   
#   this variable allow to configure the mysql innodb_lock_wait_timeout parameter (in seconds).
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_lock_wait_timeout
#
# [+innodb_rollback_on_timeout+]
#   (OPTIONAL) (default: true) 
#   
#   this variable allow to activate (true) or deactivate (false) the mysql innodb_rollback_on_timeout parameter.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_rollback_on_timeout
#
# [+innodb_log_file_size+]
#   (OPTIONAL) (default: 32M) 
#   
#   The size in bytes of each log file in a log group. The combined size of log files must be less than 4GB. 
#   The default value is 5MB. Sensible values range from 1MB to 1/N-th of the size of the buffer pool, where N is the number of log files in the group. 
#   The larger the value, the less checkpoint flush activity is needed in the buffer pool, saving disk I/O. 
#   But larger log files also mean that recovery is slower in case of a crash.
#   
#   Usually, we set the log file size to about 25% of the buffer pool size
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_log_file_size
#
# [+innodb_log_buffer_size+]
#   (OPTIONAL) (default: 1M) 
#   
#   The size in bytes of the buffer that InnoDB uses to write to the log files on disk. 
#   The default value is 1MB for the built-in InnoDB, 8MB for InnoDB Plugin. Sensible values range from 1MB to 8MB. 
#   A large log buffer enables large transactions to run without a need to write the log to disk before the transactions commit. 
#   Thus, if you have big transactions, making the log buffer larger saves disk I/O.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_log_buffer_size
#
# [+innodb_data_file_path+]
#   (OPTIONAL) (default: ibdata1:10M:autoextend) 
#   
#   The paths to individual data files and their sizes. The full directory path to each data file is formed by concatenating innodb_data_home_dir to each path specified here. 
#   The file sizes are specified in KB, MB, or GB (1024MB) by appending K, M, or G to the size value. The sum of the sizes of the files must be at least 10MB. 
#   If you do not specify innodb_data_file_path, the default behavior is to create a single 10MB auto-extending data file named ibdata1. 
#   The size limit of individual files is determined by your operating system. 
#   You can set the file size to more than 4GB on those operating systems that support big files. You can also use raw disk partitions as data files.
#   
#   syntax : file_name:file_size[:autoextend[:max:max_file_size]]
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_data_file_path
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-configuration.html
#
# [+table_open_cache+]
#   (OPTIONAL) (default: 64) 
#   
#   The number of open tables for all threads. Increasing this value increases the number of file descriptors that mysqld requires. 
#   You can check whether you need to increase the table cache by checking the Opened_tables status variable. 
#   If the value of Opened_tables is large and you do not use FLUSH TABLES often (which just forces all tables to be closed and reopened), then you should increase the value of the table_open_cache variable. 
#   Before MySQL 5.1.3, this variable is called table_cache.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_table_open_cache
#   * http://dev.mysql.com/doc/refman/5.1/en/table-cache.html
#   * http://dev.mysql.com/doc/refman/5.1/en/server-status-variables.html
#
# [+tmp_table_size+]
#   (OPTIONAL) (default: 16M) 
#   
#   The maximum size of internal in-memory temporary tables. (The actual limit is determined as the minimum of tmp_table_size and max_heap_table_size.) 
#   If an in-memory temporary table exceeds the limit, MySQL automatically converts it to an on-disk MyISAM table. 
#   Increase the value of tmp_table_size (and max_heap_table_size if necessary) if you do many advanced GROUP BY queries and you have lots of memory. 
#   This variable does not apply to user-created MEMORY tables.
#   
#   You can compare the number of internal on-disk temporary tables created to the total number of internal temporary tables created by comparing the values of the Created_tmp_disk_tables and Created_tmp_tables variables.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_tmp_table_size
#   * http://dev.mysql.com/doc/refman/5.1/en/internal-temporary-tables.html
#
# [+max_tmp_tables+]
#   (OPTIONAL) (default: 32) 
#   
#   The maximum number of temporary tables a client can keep open at the same time. (This variable does not yet do anything)
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_max_tmp_tables
#
# [+query_cache_limit+]
#   (OPTIONAL) (default: 1M) 
#   
#   Do not cache results that are larger than this number of bytes.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_query_cache_limit
#
# [+thread_cache_size+]
#   (OPTIONAL) (default: 8) 
#   
#   How many threads the server should cache for reuse. When a client disconnects, the client's threads are put in the cache if there are fewer than thread_cache_size threads there.
#   Requests for threads are satisfied by reusing threads taken from the cache if possible, and only when the cache is empty is a new thread created. This variable can be increased to improve performance if you have a lot of new connections. 
#   Normally, this does not provide a notable performance improvement if you have a good thread implementation. 
#   However, if your server sees hundreds of connections per second you should normally set thread_cache_size high enough so that most new connections use cached threads. 
#   By examining the difference between the Connections and Threads_created status variables, you can see how efficient the thread cache is.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_thread_cache_size
#
# [+query_cache_size+]
#   (OPTIONAL) (default: 16M) 
#   
#   The amount of memory allocated for caching query results. The permissible values are multiples of 1024; other values are rounded down to the nearest multiple.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_query_cache_size
#
# [+bulk_insert_buffer_size+]
#   (OPTIONAL) (default: 8M) 
#   
#   MyISAM uses a special tree-like cache to make bulk inserts faster for INSERT ... SELECT, INSERT ... VALUES (...), (...), ..., and LOAD DATA INFILE when adding data to nonempty tables. 
#   This variable limits the size of the cache tree in bytes per thread. 
#   Setting it to 0 disables this optimization.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_bulk_insert_buffer_size
#
# [+read_buffer_size+]
#   (OPTIONAL) (default: 128K) 
#   
#   Each thread that does a sequential scan allocates a buffer of this size (in bytes) for each table it scans. 
#   If you do many sequential scans, you might want to increase this value, which defaults to 131072. 
#   The value of this variable should be a multiple of 4KB. 
#   If it is set to a value that is not a multiple of 4KB, its value will be rounded down to the nearest multiple of 4KB.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_read_buffer_size
#
# [+read_rnd_buffer_size+]
#   (OPTIONAL) (default: 256K) 
#   
#   When reading rows in sorted order following a key-sorting operation, the rows are read through this buffer to avoid disk seeks. 
#   Setting the variable to a large value can improve ORDER BY performance by a lot.
#   However, this is a buffer allocated for each client, so you should not set the global variable to a large value. 
#   Instead, change the session variable only from within those clients that need to run large queries.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_read_rnd_buffer_size
#
# [+sort_buffer_size+]
#   (OPTIONAL) (default: 2M) 
#   
#   Each session that needs to do a sort allocates a buffer of this size. sort_buffer_size is not specific to any storage engine and applies in a general manner for optimization.
#   If you see many Sort_merge_passes per second in SHOW GLOBAL STATUS output, you can consider increasing the sort_buffer_size value to speed up ORDER BY or GROUP BY operations that cannot be improved with query optimization or improved indexing.
#   The entire buffer is allocated even if it is not all needed, so setting it larger than required globally will slow down most queries that sort. It is best to increase it as a session setting, and only for the sessions that need a larger size.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_sort_buffer_size
#
# [+key_buffer_size+]
#   (OPTIONAL) (default: 8M) 
#   
#   this variable allow to configure the key_buffer_size parameter.
#   Index blocks for MyISAM tables are buffered and are shared by all threads. key_buffer_size is the size of the buffer used for index blocks. The key buffer is also known as the key cache.
#   You can increase the value to get better index handling for all reads and multiple writes; on a system whose primary function is to run MySQL using the MyISAM storage engine, 25% of the machine's total memory is an acceptable value for this variable. 
#   However, you should be aware that, if you make the value too large (for example, more than 50% of the machine's total memory), your system might start to page and become extremely slow. 
#   This is because MySQL relies on the operating system to perform file system caching for data reads, so you must leave some room for the file system cache. 
#   You should also consider the memory requirements of any other storage engines that you may be using in addition to MyISAM.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_rollback_on_timeout
#
# [+join_buffer_size+]
#   (OPTIONAL) (default: 128K) 
#   
#   this variable allow to configure the join_buffer_size parameter.
#   One join buffer is allocated for each full join between two tables. For a complex join between several tables for which indexes are not used, multiple join buffers might be necessary. 
#   There is no gain from setting the buffer larger than required to hold each matching row, and all joins allocate at least the minimum size, so use caution in setting this variable to a large value globally. 
#   It is better to keep the global setting small and change to a larger setting only in sessions that are doing large joins. 
#   Memory allocation time can cause substantial performance drops if the global size is larger than needed by most queries that use it.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_rollback_on_timeout
#
# [+max_heap_table_size+]
#   (OPTIONAL) (default: 16M) 
#   
#   this variable allow to configure the max_heap_table_size parameter.
#   This variable sets the maximum size to which user-created MEMORY tables are permitted to grow. The value of the variable is used to calculate MEMORY table MAX_ROWS values.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_max_heap_table_size
#
# [+max_allowed_packet+]
#   (OPTIONAL) (default: 16M) 
#   
#   this variable allow to configure the max_allowed_packet parameter.
#   You must increase this value if you are using large BLOB columns or long strings. It should be as big as the largest BLOB you want to use. 
#   The protocol limit for max_allowed_packet is 1GB. The value should be a multiple of 1024; nonmultiples are rounded down to the nearest multiple.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_max_allowed_packet
#
# [+slow_query_log+]
#   (OPTIONAL) (default: false) 
#   
#   this variable allow to activate (true) or deactivate (false) the slow_query_log parameter.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-options.html#option_mysqld_slow-query-log
#
# [+long_query_time+]
#   (OPTIONAL) (default: 10) 
#   
#   this variable allow to define the thresold of slow queries by setting the long_query_time parameter (in seconds).
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_long_query_time
#
# [+log_queries_not_using_indexes+]
#   (OPTIONAL) (default: false) 
#   
#   this variable allow to activate (true) or deactivate (false) the log_queries_not_using_indexes parameter.
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/server-options.html#option_mysqld_log-queries-not-using-indexes
#
# [+server_charset+]
#   (OPTIONAL) (default: utf8) 
#   
#   this variable allow to configure the server charset (character-set-server) and the default charset (default-character-set).
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/charset-configuration.html
#   * http://dev.mysql.com/doc/refman/5.1/en/server-options.html#option_mysqld_character-set-server
#
# [+server_collation+]
#   (OPTIONAL) (default: utf8_general_ci) 
#   
#   this variable allow to configure the default server collation (collation-server).
#   
#   For more informations, read :
#   * http://dev.mysql.com/doc/refman/5.1/en/charset-configuration.html
#   * http://dev.mysql.com/doc/refman/5.1/en/server-options.html#option_mysqld_collation-server
#
# == Modules Dependencies
#
# [+repo+]
#   the +repo+ puppet module is needed to :
#   
#   - refresh the repository before installing package (in puppet::install)
#
# == Examples
#
# === Dedicated database server
#
# System :
# * 1 CPU with 8 cores
# * 24 Gb of RAM
#
#   class { "mysql":
#       lastversion             => false,
#       data_dir                => "/mnt/data/mysql",
#       # up to 80% of the total system RAM (19.2 Gb)
#       innodb_buffer_pool_size => "18G",
#       # ~25% of innodb_buffer_pool_size (4.5 Gb)
#       innodb_log_file_size    => "4.5G",
#       innodb_data_file_path   => "ibdata1:1G:autoextend",
#   }
#
################################################################################
class mysql (   $lastversion        = false,            $data_dir               = false, 
                $max_connections    = 64,               $max_user_connections   = 0, 
                $bind_address       = "127.0.0.1",      $port                   = "3306",           $temp_dir     = false,              $sock_path  = false,
                $default_storage_engine = "INNODB",
                $innodb_file_per_table  = true,         $innodb_buffer_pool_size = "128M",          $innodb_additional_mem_pool_size = "8M",
                $innodb_thread_concurrency = 8, 
                $innodb_flush_method = "O_DIRECT",      $innodb_flush_log_at_trx_commit = 1, 
                $innodb_lock_wait_timeout = 50,         $innodb_rollback_on_timeout = true,
                $innodb_log_file_size = "32M",          $innodb_log_buffer_size = "5M",
                $innodb_data_file_path = "ibdata1:10M:autoextend",
                $table_open_cache = 64,                 $tmp_table_size = "16M",                    $max_tmp_tables = 32,
                $query_cache_limit = "1M",              $query_cache_size = "16M",                  $bulk_insert_buffer_size = "8M",
                $thread_cache_size = 8,
                $read_buffer_size = "128K",             $read_rnd_buffer_size = "256K",             $sort_buffer_size = "2M",
                $key_buffer_size = "8M",                $join_buffer_size = "128K",
                $max_heap_table_size = "16M", 
                $max_allowed_packet = "16M",
                $slow_query_log = false,                $long_query_time = 10,                      $log_queries_not_using_indexes = false,
                $server_charset = "utf8",               $server_collation = "utf8_general_ci"
    ) {
    
    # parameters validation
    if ($lastversion != true) and ($lastversion != false) {
        fail("lastversion must be true or false")
    }

    include repo
    include mysql::params, mysql::install, mysql::config, mysql::service, mysql::secure

}
