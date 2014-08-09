h1. elasticsearch-monitoring

h2. Cluster monitoring with elasticsearch and kibana

This is an elegant way to monitor your elasticsearch cluster. See the screenshots below.

The idea is simple and straightforward:
* get statistics via nodes stats API and index them back in elasticsearch,
* repeat it periodically (e.g. every 5 minutes),
* uses a monthly index to allow manual deletion, with an alias to keep kibana access simple
* visualize cluster statistics with kibana.

h2. Installing and Running

h4. Create the Index:

Execute @scripts/elasticsearch-nodes-stats-mapping.sh@ on one of your cluster nodes.
Install the script in cron to run at the beginning of each month.

h4. Install the Script:

Copy @scripts/elasticsearch-nodes-stats.py@ to one of your cluster nodes.
Start executing it periodically, e.g. using crontab.

h4. Load the Dashboard:

Install "kibana":http://www.elasticsearch.org/overview/kibana/installation and load @dashboards/Elasticsearch Monitoring.json@.


h2. Notes

* All statistics for a single node are indexed under a single type, identified by the node's name. Use fixed (predefined) node names, otherwise any restart of elasticsearch will generate new node names and statistics for a single node will be indexed under different types (see elasticsearch "configuration":http://www.elasticsearch.org/guide/reference/setup/configuration).
* @scripts/elasticsearch-nodes-stats.py@ is a python script. It uses the http library "requests":http://docs.python-requests.org/en/latest (if not installed: "installation":http://docs.python-requests.org/en/latest/user/install/#install).
* Sampling period is defined by the executor of @scripts/elasticsearch-nodes-stats.sh@. For example, a simple crontab setup for execution every 5 minutes: @*/5    *    *       *        *     <path>/elasticsearch-nodes-stats.py@
* @scripts/elasticsearch-nodes-stats.sh@ needs to run at the beginning of each new month to create the index for that month.
* #TODO# move the index creation script to an uploaded mapping.
* There are many ways to visualize the data and the given dashboard is only one of them. Consider creating multiple dashboards according to your needs (e.g. os monitor, jvm monitor, indices monitor, etc).

h2. Screenshots

Two production nodes, sampling nodes stats every 5 minutes, keeping history for 60 days:

!screenshots/kibana-screenshot-1.png!
!screenshots/kibana-screenshot-2.png!
!screenshots/kibana-screenshot-3.png!

