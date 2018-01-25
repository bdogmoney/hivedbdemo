#ADD JAR /tmp/json-serde-1.3.8-jar-with-dependencies.jar;

drop table if exists yelp_review;

create external table yelp_reviewd(docid string, 
	review_id string,
	user_id string,
	business_id string,
	stars string,
	review_date string,
	text string, 
	useful string, 
	funny string, 
	cool string)
STORED BY 'org.apache.hadoop.hive.maprdb.json.MapRDBJsonStorageHandler' 
TBLPROPERTIES("maprdb.table.name" = "/apps/review","maprdb.column.id" = "doc_id");
