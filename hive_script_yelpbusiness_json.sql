ADD JAR /tmp/json-serde-1.3.8-jar-with-dependencies.jar;

drop table if exists yelp_business;

create external table yelp_business(DocId string, 
	business_id string,
	name string,
	neighborhood string,
	address string,
	city string,
	state string, 
	postal_code string, 
	latitude string,
	lonitude string,
	stars string,
	review_count string,
	is_open string,
	attributes struct<
		RestaurantsPriceRange2:string,
		BusinessParking:struct<
			garage:string,
			street:string,
			validated:string,
			lot:string,
			valet:string
		>,
		BikeParking:string,
		WheelchairAccessible:string
	>,
	categories array<string>,
	hours struct<
		Monday:string,
		Tuesday:string,
		Friday:string,
		Wednesday:string,
		Thursday:string,
		Sunday:string,
		Saturday:string
	> 
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' LOCATION 'maprfs:/tmp/jsonbusiness';