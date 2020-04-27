# Create a monitoring dashboard VM for Linux environments with Vagrant.

## This VM uses:

- get_cpuUsage.sh: A bash script used to get *cpu usage* by processes;
- get_memUsage.sh: A bash script used to get *memory usage* by processes;
- get_FsUsage.sh: A bash script used to get *FileSystems* usage;
- Pushgateway v0.8.0 : Prometheus scraps metrics exposed by HTTP instances and stores them. Pushgateway caches the metrics received from the scripts and expose them to Prometheus TSDB;
- Prometheus v2.9.2: Is a time series database (TSDB) used to store metrics. Prometheus will scrape Pushgateway as a target in order to retrieve and store metrics;
- Grafana v6.2: Is a dashboard monitoring tool that retrieves data from Prometheus via PromQL queries and plot them.

# Installing Vagrant

**Vagrant** is a tool for building and managing virtual machine environments in a single workflow using a [VM provider or docker](https://www.vagrantup.com/docs/providers/). 
Following the [instructions](https://www.vagrantup.com/docs/installation/) to install it.


# Starting VM using vagrant box

1. [Clone](https://github.com/macedojleo/prometetheus-grafana.git) this project
2. Access the project directory
3. Start and provisioning the Virtual Machine
 
 ```$ vagrant up --provosioning ```

 4. Access the VM using:
  
 ```$ vagrant ssh```
 
# Validating:
 
 - The Pushgateway should be listening incoming metrics on port 9091
 - Access the Prometheus conssole on http://localhost:9090/graph
 - Access the Grafana web UI on http://localhost:3000
