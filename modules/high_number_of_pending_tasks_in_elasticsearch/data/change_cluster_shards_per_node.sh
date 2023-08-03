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