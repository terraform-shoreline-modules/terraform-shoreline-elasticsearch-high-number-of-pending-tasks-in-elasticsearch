

#!/bin/bash



# Check the current memory usage of the ElasticSearch cluster.

free -h



# Check the current CPU usage of the ElasticSearch cluster.

top



# Check the ElasticSearch logs for any memory or processing related errors.

grep -i "out of memory" ${ELASTICSEARCH_LOG_FILE}



# Check the ElasticSearch configuration for any settings related to memory or processing limits.

cat ${ELASTICSEARCH_CONFIG_FILE} | grep -i "memory" | grep -i "limit"

cat ${ELASTICSEARCH_CONFIG_FILE} | grep -i "cpu" | grep -i "limit"



# Check the ElasticSearch cluster settings to ensure that it is properly optimized for the current workload.

curl -X GET "http://localhost:9200/_cluster/settings?pretty"