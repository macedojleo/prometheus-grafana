#!/bin/bash

 prometheusPort="9091"
 prometheusHost="127.0.0.1"
 metricName="MEM_USAGE" 

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
log "I" "Collecting data..."
msgs=$(ps haux | awk -v METRIC_NAME="$metricName" '{
	USER=$1;
	PID=$2;
	CPU=$3;
	MEM=$4;
	VSZ=$5;
	START=$9;
	TIME=$10;
	COMMAND=$11;
	print METRIC_NAME"{process=\""COMMAND"\",user=\""USER"\",pid=\""PID"\"}", MEM
  }
        END { print "\n" }'
)
log "I" "Sending info to Prometheus gateway..."

curl -X POST -H  "Content-Type: text/plain" --data "$msgs
   " http://localhost:9091/metrics/job/top/instance/machine

log "X" "End Process"
