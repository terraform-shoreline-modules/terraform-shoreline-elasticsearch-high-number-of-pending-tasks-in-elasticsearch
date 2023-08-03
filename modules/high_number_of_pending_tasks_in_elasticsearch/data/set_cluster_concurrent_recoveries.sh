curl -XPUT "http://localhost:9200/_cluster/settings" \

-H 'Content-Type: application/json' -d'

{

  "transient": {

    "cluster.routing.allocation.node_concurrent_recoveries": ${DESIRED_CONCURRENT_RECOVERIES}

  }

}

'