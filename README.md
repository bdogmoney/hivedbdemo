# hivedbdemo
Hive vs DB Demo with SI

Use bgehrke-hive-db6
Hive Query
su - mapr

hive

ADD JAR /tmp/json-serde-1.3.8-jar-with-dependencies.jar;

select a.name, avg(b.stars) as AvgStars from yelp_business a join yelp_review b on (a.business_id = b.business_id) where b.business_id = 'Ue6-WhXvI-_1xUIuapl0zQ' group by a.name;


Drill Query
sqlline -u jdbc:drill:drillbit=172.16.9.224

alter session set `planner.index.noncovering_selectivity_threshold` = 0.9;

select a.name, avg(b.stars) as AvgStars from dfs.root.`/apps/business` as a join dfs.root.`/apps/review` as b on a.business_id = b.business_id where b.business_id = 'Ue6-WhXvI-_1xUIuapl0zQ' group by a.name;

