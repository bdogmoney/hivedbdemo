#!/bin/bash

#
#pull in data from the edge node
#
mkdir /mapr2
mount -o hard,nolock 172.16.9.138:/mapr /mapr2
cp -a /mapr/my.cluster.com/tmp/dataset /mapr/my.cluster.com/tmp
mkdir /mapr/my.cluster.com/tmp/jsonbusiness
mkdir /mapr/my.cluster.com/tmp/jsonuser
mkdir /mapr/my.cluster.com/tmp/jsonreview
#put the data in its own directory for the hivescripts
cp /mapr/my.cluster.com/tmp/dataset/business.json /mapr/my.cluster.com/tmp/jsonbusiness
cp /mapr/my.cluster.com/tmp/dataset/user.json /mapr/my.cluster.com/tmp/jsonuser
cp /mapr/my.cluster.com/tmp/dataset/review.json /mapr/my.cluster.com/tmp/jsonreview

echo "The data has been copied over and put in the right locations"

#
#Move the data into mapr-db
#
mapr importJSON -idField business_id -src /tmp/business.json -dst /apps/business -mapreduce false
mapr importJSON -idField review_id -src /tmp/review.json -dst /apps/review -mapreduce false
mapr importJSON -idField user_id -src /tmp/user.json -dst /apps/user -mapreduce false
maprcli table cf edit -path /apps/business -cfname default -readperm p -writeperm p
maprcli table cf edit -path /apps/review -cfname default -readperm p -writeperm p
maprcli table cf edit -path /apps/user -cfname default -readperm p -writeperm p

echo "All the data is in the DB with the authority changed"

#
#create the indexes for the db files
#
maprcli table index add -path /apps/business -index idx_biz_id -indexedfields business_id
maprcli table index add -path /apps/review -index idx_biz_id -indexedfields business_id

echo "Indexes have been built"

#
#Move the JSON Serde jar to the right location
#

cp /gitrepo/hivedbdemo/json-serde-1.3.8-jar-with-dependencies.jar /opt/mapr/hive/hive-2.1/lib
echo "Serde Jar has been moved"

#
#run the hive scripts
#

hive -f /gitrepo/hivedbdemo/hive_script_yelpbusiness_json.sql
hive -f /gitrepo/hivedbdemo/hive_script_yelpreview_json.sql
hive -f /gitrepo/hivedbdemo/hive_script_yelpuser_json.sql

echo "Hive tables have been created"







