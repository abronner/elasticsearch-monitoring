# Elasticsearch Monitoring

## Cluster monitoring with elasticsearch and kibana
This is and simple way to monitor your elasticsearch cluster and is a fork and enhancement on [the original by abronner](https://github.com/abronner/elasticsearch-monitoring). It assumes you already have Elasticsearch and Kibana installed.

The idea is simple and straightforward:

1. Get statistics via the nodes stats API and then index them back in elasticsearch,
2. Repeat it periodically (e.g. every N minutes),
3. Use a daily index as per ELK standards,
4. Visualize cluster statistics with kibana.

## Installing and Running
### Add the template:
Execute scripts/elasticsearch-nodesstats-template.sh on one of your cluster nodes. This will create a template for all indexes that are created.

### Install the Script:
Copy scripts/elasticsearch-nodesstats.py to one of your cluster nodes.
Start executing it periodically, e.g. using cron (below).

### Load the Dashboard:
Load dashboards/Elasticsearch Monitoring.json into kibana.

## Screenshots
**Please note, these are out of date but should give you an idea on what's possible**

Two production nodes, sampling nodes stats every 5 minutes, keeping history for 60 days:
![](https://raw.githubusercontent.com/markwalkom/elasticsearch-monitoring/master/screenshots/kibana-screenshot-1.png)
![](https://raw.githubusercontent.com/markwalkom/elasticsearch-monitoring/master/screenshots/kibana-screenshot-2.png)
![](https://raw.githubusercontent.com/markwalkom/elasticsearch-monitoring/master/screenshots/kibana-screenshot-3.png)

## Notes
* All statistics for a single node are indexed under a single type, identified by the node's name. Use fixed (predefined) node names otherwise any restart of elasticsearch will generate new node names and statistics for a single node will be indexed under a different type.
* scripts/elasticsearch-nodes-stats.py is a python script. It uses the http library [requests](http://docs.python-requests.org/en/latest) (if not installed see [here](http://docs.python-requests.org/en/latest/user/install/#install)).
* Sampling period is defined by the executor of scripts/elasticsearch-nodes-stats.sh. For example, a simple crontab setup for execution every 5 minutes: 
````
*/5    *    *       *        *     <path>/elasticsearch-nodes-stats.py
````
* scripts/elasticsearch-nodes-stats.sh needs to run at the beginning of each new day to create the index for that month, eg with cron;
````
0    0    *       *        *     <path>/elasticsearch-nodes-stats-mapping.sh
````
* There are many ways to visualize the data and the provided dashboard is only one of them. Consider creating multiple dashboards according to your needs (e.g. os monitor, jvm monitor, indices monitor, etc).

## Todo
* Split the graphs, maybe a high level page and then subpages for OS, Memory/Heap, ES specifics etc.
* Should this be a plugin instead?