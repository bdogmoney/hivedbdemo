--ADD JAR /tmp/json-serde-1.3.8-jar-with-dependencies.jar;

drop table if exists yelp_review;

create external table yelp_review(DocId string, 
	review_id string,
	user_id string,
	business_id string,
	stars string,
	review_date string,
	text string, 
	useful string, 
	funny string, 
	cool string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' LOCATION 'maprfs:/tmp/jsonreview';