#!/bin/bash

 prometheusPort="9091"
 prometheusHost="127.0.0.1"
 metricName="FS_USAGE" 

 log () {

	if [[ -z $1 || -z $2 ]]; then
		echo "log error";
		exit 1
	fi

	msgType=$1
	msgContent=$2
	date=`date +"%F %H:%M:%S"`

	echo "$msgType | $date | $msgContent" >> /tmp/monitoring.log

 }


 log "S" "Starting $0 process"
 log "I" "Collecting FS's info..."

msgs=$(df | sed 1d | sed "s#%#.#g" | awk -v METRIC_NAME="$metricName" '{
	DISK=$1;
	SIZE=$2;
	USED=$3;
	AVAILABLE=$4;
	USE_PERC=$5;
	MOUNT_POINT=$6;
	print METRIC_NAME"{mount_point=\""MOUNT_POINT"\",used=\""USED"\",available=\""AVAILABLE"\"}", USE_PERC
  }'
)
 log "I" "Sending info to Prometheus gateway..."

     curl -X POST -H  "Content-Type: text/plain" --data "$msgs
   " http://localhost:9091/metrics/job/top/instance/machine

 log "X" "End Process"
