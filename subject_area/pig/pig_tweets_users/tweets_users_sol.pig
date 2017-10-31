REGISTER  /home/cloudera/piggybank.jar;

A = LOAD 'path/tweets.csv' USING org.apache.pig.piggybank.storage.CSVLoader() AS (tweetid:chararray, tweet:chararray, userid:chararray);


B = LOAD 'path/users.csv' USING PigStorage(',') AS (userid:chararray, name:chararray, state:chararray);

--1.
C = FILTER B BY state=='NY';
DUMP C;

--2.
D = FILTER A BY tweet matches '.*favorite.*';
E = ORDER D BY tweetid;
DUMP E;

--3.
F = GROUP A BY userid;
G = FOREACH F GENERATE group, SIZE(A);
DUMP G;

--4.
H =  ORDER G BY $1 DESC;
DUMP H;

--5.
I = JOIN A BY userid, B BY userid;
J = FOREACH I GENERATE name, tweet;
K = GROUP J BY name;
L = FOREACH K GENERATE group, SIZE(J);
M = FILTER L BY $1 > 1;
N = FOREACH M GENERATE group;
DUMP N;

--6.
I = JOIN B BY userid LEFT OUTER, A BY userid;
J = FOREACH I GENERATE name, tweet;
K = GROUP J BY name;
describe K;
L = FOREACH K GENERATE group, SIZE(J);
M = FILTER L BY $1 == 0;
DUMP M;

--7.
I = JOIN A BY userid, B BY userid;
J = FOREACH I GENERATE name, tweet;
K = GROUP J BY name;
L = FOREACH K GENERATE group, SIZE(J);
DUMP L;

--8.
I = JOIN A BY userid, B BY userid;
J = FOREACH I GENERATE name, tweet;
K = GROUP J BY name;
L = FOREACH K GENERATE group, SIZE(J);
M = ORDER L BY $1 DESC;
DUMP M;
