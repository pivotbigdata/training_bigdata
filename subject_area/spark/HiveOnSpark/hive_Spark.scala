import org.apache.spark.sql.hive.HiveContext

val hc = new org.apache.spark.sql.hive.HiveContext(sc)

import hiveContext._

val hive_tables=hiveContext.sql("show tables").foreach(println)

val create_table = hc.sql("create table spark_olympic_new_spark(athelete STRING,age INT,country STRING,year STRING,closing STRING,sport STRING,gold INT,silver INT,bronze INT,total INT) row format delimited fields terminated by '\t' stored as textfile")

val sqlQuery = hc.sql("""select * from
 staging.employee_usa""")