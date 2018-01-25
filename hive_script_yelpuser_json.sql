ADD JAR /tmp/json-serde-1.3.8-jar-with-dependencies.jar;

drop table if exists yelp_user;

create external table yelp_user(DocId string, 
	user_id string,
	name string,
	review_count string,
	yelping_since string,
	friends array<string>,
	useful string, 
	funny string, 
	cool string, 
	fans string, 
	elite array<string>,
	average_stars string, 
	compliment_hot string,
	compliment_more string, 
	compliment_profile string,
	compliment_cute string,
	compliment_list string, 
	compliment_note string, 
	compliment_plain string,
	compliment_cool string,
	compliment_funny string,
	compliment_writer string,
	compliment_photos string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' LOCATION 'maprfs:/tmp/jsonuser';
