#!/bin/bash

# This script creates an index called 'nodes_stats_YYYYMMDD'
# and then aliases it to nodes_stats.
# The index uses 8 shards and has 1 replica (change settings if needed).
# The default mapping defines the following:
# - fields called '*timestamp' are indexed as dates
# - string fields are not analyzed

# This originally used document ttl which isn't efficient. Instead
# the nodes_stats alias is moved monthly and old indexes can then be manually deleted

THISMONTH=`date +%Y%m`
LASTMONTH=`date --date='last month' +%Y%m`

# Create new month's index
function createThisMonthsIndex() {
curl -XPUT "http://localhost:9200/nodes_stats_${THISMONTH}" -d "
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

# Switch the alias to the new month
function recreateAliases() {
curl -XDELETE "http://localhost:9200/nodes_stats_${LASTMONTH}/_alias/nodes_stats"
curl -XPUT "http://localhost:9200/nodes_stats_${THISMONTH}/_alias/nodes_stats"
}

# Now run
createThisMonthsIndex
recreateAliases
