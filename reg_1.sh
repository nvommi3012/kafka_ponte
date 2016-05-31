#!/bin/bash 

#Creates topics in Kafka Cluster and triggers publishers in each location to register themselves as 'publishers' to that topic by sending a 'dummy' message

num_of_topics=50

for (( topic_id = 1; topic_id <= num_of_topics; topic_id++ ))
do
	cd --
	cd /media/nithin/Volumec/nodejs/nodejs/lib/node_modules/ponte/examples
	echo "----------------Registering Publishers on Topic $((topic_id))--------------------"

	node mqtt_client.js pub 1 2 topic$((topic_id)) kafka_ncal 0 &

done
