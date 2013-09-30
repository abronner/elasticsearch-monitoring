#!bin/bash

# this script creates an index called 'nodes_stats'
# the index uses 1 shard and has 1 replica (change settings if needed) 
# the default mapping defines the following:
# - time to live (ttl) for all documents (default: 60 days)
# - fields called '*timestamp' are indexed as dates
# - string fields are not analyzed

curl -XPUT 'http://localhost:9200/nodes_stats' -d '
{
    "settings" : {
        "number_of_shards" : 1,
        "number_of_replicas" : 1
    },
    "mappings" : {
        "_default_" : {
            "_all" : {"enabled" : false},
            "_ttl" : {
                "enabled" : true,
                "default" : "60d"
            },
            "dynamic_templates" : [
            {
                "timestamps_as_date" : {
                    "match_pattern" : "regex",
                    "path_match" : ".*timestamp",
                    "mapping" : {
                        "type" : "date"
                    }
                }
            },
            {
                "strings_not_analyzed" : {
                    "match" : "*",
                    "match_mapping_type" : "string",
                    "mapping" : {
                        "type" : "string",
                        "index" : "not_analyzed"
                    }
                }
            }
            ]
        }
    }
}'

