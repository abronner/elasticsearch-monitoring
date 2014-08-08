#!/bin/bash

# This script creates an index called 'nodes_stats_YYYYMMDD'
# The index uses 8 shards and has 1 replica (change settings if needed).
# The default mapping defines the following:
# - fields called '*timestamp' are indexed as dates
# - string fields are not analyzed

# This originally used document ttl which isn't efficient. Instead
# the nodes_stats alias is moved monthly and old indexes can then be manually deleted

TODAY=`date +%Y.%m.%d`

# Create new month's index
function createTodaysIndex() {
curl -XPUT "http://localhost:9200/nodesstats-${TODAY}" -d "
{
    \"settings\" : {
        \"number_of_shards\" : 8,
        \"number_of_replicas\" : 1
    },
    \"mappings\" : {
        \"_default_\" : {
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
}

# Now run
createTodaysIndex
