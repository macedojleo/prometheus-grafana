#!/bin/bash

 workdir=/vagrant/work

 if [ ! -d $workdir ]; then
	 mkdir $workdir
 fi

 log () {

	if [[ -z $1 || -z $2 ]]; then
		echo "log error";
		exit 1
	fi
 msgType=$1
 msgContent=$2
 date=`date +"%F %H:%M:%S"`
 echo "$msgType | $date | $msgContent"

}

 #  Getting the binaries files

  # 1. PushGateway

 cd $workdir

      if [ ! -f pushgateway-0.8.0.linux-amd64.tar.gz ]; then

        log "INFO" "Getting pushgateway files..."

      	wget https://github.com/prometheus/pushgateway/releases/download/v0.8.0/pushgateway-0.8.0.linux-amd64.tar.gz

	log "INFO" "Unpacking pushgateway files..."

	tar -xvzf pushgateway-0.8.0.linux-amd64.tar.gz
      fi

      log "INFO" "Starting pushgateway service..."

      cd pushgateway-0.8.0.linux-amd64/
      nohup ./pushgateway &
 
  # 2. Prometheus

      cd $workdir

      if [ ! -f prometheus-2.9.2.linux-amd64.tar.gz ]; then

	log "INFO" "Getting prometheus files..."

	wget https://github.com/prometheus/prometheus/releases/download/v2.9.2/prometheus-2.9.2.linux-amd64.tar.gz
	
	log "INFO" "Unpacking prometheus files..."
	
	tar -xvzf prometheus-2.9.2.linux-amd64.tar.gz
      fi

      log "INFO" "Starting prometheus service..."

      cd prometheus-2.9.2.linux-amd64/
      cp /vagrant/prometheus.yml .
      nohup ./prometheus &

  # 3. Grafana
     
      cd $workdir

      log "INFO" "Updating apt and its repository list..." 

      wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
      sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"  
      sudo apt update

      log "INFO" "Installing Grafana..."

      sudo apt -y install grafana

      log "I" "Installing Grafana..."

      sudo systemctl start grafana-server 
      sudo systemctl status grafana-server
      sudo systemctl enable grafana-server
      sudo systemctl daemon-reload

 # Scheduling jobs

 #Run each minute
 chmod +x /vagrant/get_cpuUsage.sh

 if [ ! -f $workdir/.croncpu ]; then

 echo "* * * * * /vagrant/get_cpuUsage.sh" >> /var/spool/cron/crontabs/`whoami`

 touch $workdir/.croncpu

 fi

 #Run each minute
 chmod +x /vagrant/get_cpuUsage.sh

  if [ ! -f $workdir/.cronmem ]; then

 echo "* * * * * /vagrant/get_memUsage.sh" >> /var/spool/cron/crontabs/vagrant

 touch $workdir/.cronmem

 fi

 #Run each minute
 chmod +x /vagrant/get_FsUsage.sh

 if [ ! -f $workdir/.cronfs ]; then

 echo "* * * * * /vagrant/get_FsUsage.sh" >> /var/spool/cron/crontabs/vagrant

 touch $workdir/.cronfs
 fi

 log "I" "Starting cron service..."
 sudo service cron start
