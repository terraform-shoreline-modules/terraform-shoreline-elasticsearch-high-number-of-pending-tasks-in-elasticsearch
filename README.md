
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High number of pending tasks in ElasticSearch.
---

This incident type refers to an alert triggered by a monitoring system indicating that the number of pending tasks in ElasticSearch is high. This can be an issue because it may indicate that the system is overloaded and unable to process all the incoming tasks, which can result in performance degradation or even downtime. The incident needs to be investigated and resolved as soon as possible to ensure the system is functioning properly.

### Parameters
```shell
# Environment Variables

export ELASTICSEARCH_NODE="PLACEHOLDER"

export DESIRED_NODE_COUNT="PLACEHOLDER"

export CLUSTER_NAME="PLACEHOLDER"

export DESIRED_SHARDS_PER_NODE="PLACEHOLDER"

export DESIRED_CONCURRENT_REBALANCE="PLACEHOLDER"

export DESIRED_CONCURRENT_RECOVERIES="PLACEHOLDER"

export ELASTICSEARCH_LOG_FILE="PLACEHOLDER"

export ELASTICSEARCH_CONFIG_FILE="PLACEHOLDER"
```

## Debug

### Check if ElasticSearch service is running
```shell
systemctl status elasticsearch.service
```

### Check ElasticSearch logs for any errors or warnings
```shell
journalctl -u elasticsearch.service
```

### Check the status of the ElasticSearch cluster
```shell
curl -XGET '${ELASTICSEARCH_NODE}:9200/_cat/health?v'
```

### Check the status of ElasticSearch nodes in the cluster
```shell
curl -XGET '${ELASTICSEARCH_NODE}:9200/_cat/nodes?v'
```

### Check the number of pending tasks in the ElasticSearch cluster
```shell
curl -XGET '${ELASTICSEARCH_NODE}:9200/_cluster/pending_tasks'
```

### Check the metrics for ElasticSearch
```shell
curl -XGET '${ELASTICSEARCH_NODE}:9200/_cat/indices?v'
```

### The ElasticSearch cluster may be lacking sufficient resources, such as memory or processing power, to handle the volume of tasks it is receiving.
```shell


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


```

## Repair

### Define variables
```shell
ES_NODE_COUNT=${DESIRED_NODE_COUNT}
```

### Scale the ElasticSearch cluster
```shell
curl -XPUT "http://localhost:9200/_cluster/settings" \

-H 'Content-Type: application/json' -d'

{

  "persistent": {

    "cluster.routing.allocation.total_shards_per_node":"${DESIRED_SHARDS_PER_NODE}"

  },

  "transient": {

    "cluster.routing.allocation.enable": "all"

  }

}

'
```

### Update the elasticsearch cluster settings to change the concurrent rebalance limit.
```shell
curl -XPUT "http://localhost:9200/_cluster/settings" \

-H 'Content-Type: application/json' -d'

{

  "transient": {

    "cluster.routing.allocation.cluster_concurrent_rebalance": ${DESIRED_CONCURRENT_REBALANCE}

  }

}

'
```

### Update elasticsearch cluster settings to set desired number of concurrent recoveries.
```shell
curl -XPUT "http://localhost:9200/_cluster/settings" \

-H 'Content-Type: application/json' -d'

{

  "transient": {

    "cluster.routing.allocation.node_concurrent_recoveries": ${DESIRED_CONCURRENT_RECOVERIES}

  }

}

'
```