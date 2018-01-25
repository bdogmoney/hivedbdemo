#!/bin/bash

#
#pull in data from the edge node
#
if [ ! -d /mapr2 ]; then 
	mkdir /mapr2
else
	echo "mapr2 already exists"
fi

#put the data in its own directory for the hivescripts
if [ ! -d "/mapr/my.cluster.com/tmp/dataset" ]; then
	if [ ! -d /mapr2/my.cluster.com/tmp/dataset]; then
		mount -o hard,nolock 172.16.9.138:/mapr /mapr2
		cp -a /mapr2/my.cluster.com/tmp/dataset /mapr/my.cluster.com/tmp
	else
		cp -a /mapr2/my.cluster.com/tmp/dataset /mapr/my.cluster.com/tmp
	fi
fi

if [ ! -d "/mapr/my.cluster.com/tmp/jsonbusiness" ]; then 
	mkdir /mapr/my.cluster.com/tmp/jsonbusiness
	cp /mapr/my.cluster.com/tmp/dataset/business.json /mapr/my.cluster.com/tmp/jsonbusiness
fi

if [ ! -d "/mapr/my.cluster.com/tmp/jsonuser" ]; then
	mkdir /mapr/my.cluster.com/tmp/jsonuser
	cp /mapr/my.cluster.com/tmp/dataset/user.json /mapr/my.cluster.com/tmp/jsonuser
fi

if [ ! -d "/mapr/my.cluster.com/tmp/jsonreview" ]; then
	mkdir /mapr/my.cluster.com/tmp/jsonreview
	cp /mapr/my.cluster.com/tmp/dataset/review.json /mapr/my.cluster.com/tmp/jsonreview
fi

echo "The data has been copied over and put in the right locations"

#
#Move the data into mapr-db
#

if [ ! -f "mapr/my.cluster.com/apps/business" ]; then
	mapr importJSON -idField business_id -src /mapr/my.cluster.com/tmp/dataset/business.json -dst /apps/business -mapreduce false
	maprcli table cf edit -path /apps/business -cfname default -readperm p -writeperm p
	maprcli table index add -path /apps/business -index idx_biz_id -indexedfields business_id
fi

if [ ! -f "mapr/my.cluster.com/apps/review" ]; then
	mapr importJSON -idField review_id -src /mapr/my.cluster.com/tmp/dataset/review.json -dst /apps/review -mapreduce false
	maprcli table cf edit -path /apps/review -cfname default -readperm p -writeperm p
	maprcli table index add -path /apps/review -index idx_biz_id -indexedfields business_id
fi 

if [ ! -f "mapr/my.cluster.com/apps/user" ]; then
	mapr importJSON -idField user_id -src /mapr/my.cluster.com/tmp/dataset/user.json -dst /apps/user -mapreduce false
	maprcli table cf edit -path /apps/user -cfname default -readperm p -writeperm p
fi

echo "All the data is in the DB with the authority changed and indexes built"

#
#Move the JSON Serde jar to the right location
#

if [ ! -f "/opt/mapr/hive/hive-2.1/lib/json-serde-1.3.8-jar-with-dependencies.jar" ]; then
	cp /gitrepo/hivedbdemo/json-serde-1.3.8-jar-with-dependencies.jar /opt/mapr/hive/hive-2.1/lib
	echo "Serde Jar has been moved"
fi

#
#run the hive scripts
#

hive -f /gitrepo/hivedbdemo/hive_script_yelpbusiness_json.sql
hive -f /gitrepo/hivedbdemo/hive_script_yelpreview_json.sql
hive -f /gitrepo/hivedbdemo/hive_script_yelpuser_json.sql

echo "Hive tables have been created"







