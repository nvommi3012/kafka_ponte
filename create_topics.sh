#!/bin/bash 

#Creates topics in Kafka Cluster and triggers publishers in each location to register themselves as 'publishers' to that topic by sending a 'dummy' message

#Check the path before running the script
num_of_topics=500
current_topic=1
cd --
cd /media/nithin/Volumec/eclipse/Workspace/kafka/kafka/
rm reassign2.json
touch reassign2.json
foo="{\"version\":1,\"partitions\":["
echo $foo >> reassign2.json
for (( topic_id = current_topic; topic_id <= num_of_topics; topic_id++ ))
do

	echo "----------------Creating  topic$((topic_id)) in Kafka----------------"
	bin/kafka-topics.sh --create --zookeeper kafka_ncal:2181 --replication-factor 1 --partitions 1 --topic topic$((topic_id))
	foo="{\"topic\":\"topic$((topic_id))\",\"partition\":0,\"replicas\":[2]},"
	if [ $topic_id == $num_of_topics ]
	then
		echo $num_of_topics	
		foo="{\"topic\":\"topic$((topic_id))\",\"partition\":0,\"replicas\":[2]}"
	fi
	echo $foo >> reassign2.json
done
foo="]}"
echo $foo >> reassign2.json

bin/kafka-reassign-partitions.sh --zookeeper kafka_ncal:2181 --reassignment-json-file reassign2.json --execute

cd --
cd /media/nithin/Volumec/nodejs/nodejs/lib/node_modules/ponte/examples

for (( topic_id = current_topic; topic_id <= num_of_topics; topic_id++ ))
do
	echo "----------------Registering Publishers on Topic $((topic_id))--------------------"

	node mqtt_client.js pub 1 2 topic$((topic_id)) kafka_ncal 0 &
	node mqtt_client.js pub 1 2 topic$((topic_id)) kafka_sydney 0 &

done



