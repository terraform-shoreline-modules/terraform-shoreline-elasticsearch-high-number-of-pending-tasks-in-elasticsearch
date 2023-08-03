curl -XPUT "http://localhost:9200/_cluster/settings" \

-H 'Content-Type: application/json' -d'

{

  "transient": {

    "cluster.routing.allocation.cluster_concurrent_rebalance": ${DESIRED_CONCURRENT_REBALANCE}

  }

}

'