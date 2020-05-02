# MySQL CLI examples

- Login to mysql

    ```bash
    mysql -h 127.0.0.1 -u root --database bookstore_schema -p
    ```
    
- Run a single query and exit. (Useful to dump query output to a file)

    This will ask for the password
    
    ```bash
    mysql -e "select * from book" -h 127.0.0.1 -u root --database bookstore_schema -p
    ```

    To avoid entering password...
    
    ```bash
    mysql -e "select * from book" -h 127.0.0.1 -u root --database bookstore_schema --password=Book123
    ```

- Get mysql db data dump, ignoring some tables

    ```bash
    mysqldump \
        -h localhsot \
        -u hellouser \
        -p bookstore_schema \
        --ignore-table=bookstore_schema.userlog \
        --ignore-table=bookstore_schema.bigtable \
    > bookstoredump.sql
    ```

- Load SQL dump to db schema

    ```bash
    mysql -h 127.0.0.1 -u root -p bookstore_schema < bookstoredump.sql
    ```

- Show create SQL query for a table

    ```SQL
    SHOW CREATE TABLE tablename;
    ```

- Show indexes applied on a table;

    ```sql
    SHOW INDEXES FROM tablename;
    ```

- Insert script for a query

    ```bash
    mysqldump -t -h localhost -u hellouser -p bookstore_schema.bookstable --where "book_id IN (12455,10245,12895)" > book_inserts.sql
    ```

- Look for a locked table or a long running query

    - Check all the running threads

        ```
        SHOW PROCESSLIST;
        ```

    - Check all open tables

        ```sql
        SHOW OPEN TABLES WHERE In_use > 0;
        ```
    - Check innodb engine status.

        ```sql
        SHOW ENGINE InnoDB STATUS;
        ```

- Variables

    ```sql
    SHOW VARIABLES;
    SHOW VARIABLES LIKE 'transaction_isolation'
    SHOW SESSION VARIABLES LIKE 'sql_mode'
    SELECT @@transaction_isolation;
    SELECT @@GLOBAL.transaction_isolation;
    ```

- Query output to file (Not worth it, use `mysql -e`)

    ```SQL
    SELECT field1, field2
    FROM table1
    INTO OUTFILE '/path/to/file.csv'
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"'
    FIELDS ESCAPED BY '\'
    LINES TERMINATED BY '\n';
    ```
    
    Got this...
    
    ```
    ERROR 1290 (HY000): The MySQL server is running with the --secure-file-priv option so it cannot execute this statement
    ```
    
    Check the value of the variable.
    
    ```sql
    mysql> select @@global.secure_file_priv;
    +---------------------------+
    | @@global.secure_file_priv |
    +---------------------------+
    | NULL                      |
    +---------------------------+
    1 row in set (0.00 sec)
    ```
    
    We have to edit the `/etc/mysql/my.cnf` and set the path as a value for `secure-file-priv` key. This is where the files can be saved. (Didn't try this!)
    
    I don't think it ends here. The user running this command has to have some privileges. Also, the command saves the file on the server.
