resource "shoreline_notebook" "high_number_of_pending_tasks_in_elasticsearch" {
  name       = "high_number_of_pending_tasks_in_elasticsearch"
  data       = file("${path.module}/data/high_number_of_pending_tasks_in_elasticsearch.json")
  depends_on = [shoreline_action.invoke_elasticsearch_config_check,shoreline_action.invoke_change_cluster_shards_per_node,shoreline_action.invoke_rebalance_settings,shoreline_action.invoke_set_cluster_concurrent_recoveries]
}

resource "shoreline_file" "elasticsearch_config_check" {
  name             = "elasticsearch_config_check"
  input_file       = "${path.module}/data/elasticsearch_config_check.sh"
  md5              = filemd5("${path.module}/data/elasticsearch_config_check.sh")
  description      = "The ElasticSearch cluster may be lacking sufficient resources, such as memory or processing power, to handle the volume of tasks it is receiving."
  destination_path = "/agent/scripts/elasticsearch_config_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "change_cluster_shards_per_node" {
  name             = "change_cluster_shards_per_node"
  input_file       = "${path.module}/data/change_cluster_shards_per_node.sh"
  md5              = filemd5("${path.module}/data/change_cluster_shards_per_node.sh")
  description      = "Scale the ElasticSearch cluster"
  destination_path = "/agent/scripts/change_cluster_shards_per_node.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "rebalance_settings" {
  name             = "rebalance_settings"
  input_file       = "${path.module}/data/rebalance_settings.sh"
  md5              = filemd5("${path.module}/data/rebalance_settings.sh")
  description      = "Update the elasticsearch cluster settings to change the concurrent rebalance limit."
  destination_path = "/agent/scripts/rebalance_settings.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "set_cluster_concurrent_recoveries" {
  name             = "set_cluster_concurrent_recoveries"
  input_file       = "${path.module}/data/set_cluster_concurrent_recoveries.sh"
  md5              = filemd5("${path.module}/data/set_cluster_concurrent_recoveries.sh")
  description      = "Update elasticsearch cluster settings to set desired number of concurrent recoveries."
  destination_path = "/agent/scripts/set_cluster_concurrent_recoveries.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_elasticsearch_config_check" {
  name        = "invoke_elasticsearch_config_check"
  description = "The ElasticSearch cluster may be lacking sufficient resources, such as memory or processing power, to handle the volume of tasks it is receiving."
  command     = "`chmod +x /agent/scripts/elasticsearch_config_check.sh && /agent/scripts/elasticsearch_config_check.sh`"
  params      = ["ELASTICSEARCH_LOG_FILE","ELASTICSEARCH_CONFIG_FILE"]
  file_deps   = ["elasticsearch_config_check"]
  enabled     = true
  depends_on  = [shoreline_file.elasticsearch_config_check]
}

resource "shoreline_action" "invoke_change_cluster_shards_per_node" {
  name        = "invoke_change_cluster_shards_per_node"
  description = "Scale the ElasticSearch cluster"
  command     = "`chmod +x /agent/scripts/change_cluster_shards_per_node.sh && /agent/scripts/change_cluster_shards_per_node.sh`"
  params      = ["DESIRED_SHARDS_PER_NODE"]
  file_deps   = ["change_cluster_shards_per_node"]
  enabled     = true
  depends_on  = [shoreline_file.change_cluster_shards_per_node]
}

resource "shoreline_action" "invoke_rebalance_settings" {
  name        = "invoke_rebalance_settings"
  description = "Update the elasticsearch cluster settings to change the concurrent rebalance limit."
  command     = "`chmod +x /agent/scripts/rebalance_settings.sh && /agent/scripts/rebalance_settings.sh`"
  params      = ["DESIRED_CONCURRENT_REBALANCE"]
  file_deps   = ["rebalance_settings"]
  enabled     = true
  depends_on  = [shoreline_file.rebalance_settings]
}

resource "shoreline_action" "invoke_set_cluster_concurrent_recoveries" {
  name        = "invoke_set_cluster_concurrent_recoveries"
  description = "Update elasticsearch cluster settings to set desired number of concurrent recoveries."
  command     = "`chmod +x /agent/scripts/set_cluster_concurrent_recoveries.sh && /agent/scripts/set_cluster_concurrent_recoveries.sh`"
  params      = ["DESIRED_CONCURRENT_RECOVERIES"]
  file_deps   = ["set_cluster_concurrent_recoveries"]
  enabled     = true
  depends_on  = [shoreline_file.set_cluster_concurrent_recoveries]
}

