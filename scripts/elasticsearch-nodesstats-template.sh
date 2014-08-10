#!/bin/bash

# Creates the mapping for any and all new indexes

curl -XPUT "http://localhost:9200/_template/nodesstats" -d "
{
    \"order\" : 0,
    \"template\": \"nodesstats-*\",
    \"settings\" : {
        \"number_of_shards\" : 3,
        \"number_of_replicas\" : 1
    },
    \"mappings\" : {
        \"node_stats\" : {
            \"_all\" : {\"enabled\" : false},
            \"dynamic_templates\" : [
            {
                \"timestamps_as_date\" : {
                    \"match_pattern\" : \"regex\",
                    \"path_match\" : \".*timestamp\",
                    \"mapping\" : {
                        \"type\" : \"date\"
                    }
                }
            },
            {
                \"strings_not_analyzed\" : {
                    \"match\" : \"*\",
                    \"match_mapping_type\" : \"string\",
                    \"mapping\" : {
                       \"type\" : \"string\",
                       \"index\" : \"not_analyzed\"
                    }
                }
            }
            ]
        }
    }
}"
