REGISTER piggybank.jar

A =  LOAD 'xmls/hadoop_books.xml' using org.apache.pig.piggybank.storage.XMLLoader('BOOK') as (x:chararray);

B = foreach A GENERATE FLATTEN(REGEX_EXTRACT_ALL(x,'<BOOK>\\s*<TITLE>(.*)</TITLE>\\s*<AUTHOR>(.*)</AUTHOR>\\s*<COUNTRY>(.*)</COUNTRY>\\s*<COMPANY>(.*)</COMPANY>\\s*<PRICE>(.*)</PRICE>\\s*<YEAR>(.*)</YEAR>\\s*</BOOK>'));

dump B;