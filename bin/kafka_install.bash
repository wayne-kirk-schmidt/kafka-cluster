#!/usr/bin/env bash

### Set up basic path and permissions to assist the script
umask 022
export PATH="/usr/bin:/usr/local/bin:/sbin:/usr/sbin:$PATH"

### Define the bin and the etc directory as related to the running script
export BINDIR=$(dirname "$(realpath "$0")")
export ETCDIR=$( realpath $BINDIR/../etc )

### Define the download directory
export DOWNLOAD_DIR="/var/tmp/downloads"

### Setup apt-get and following scripts to be non-interactive
export DEBIAN_FRONTEND=noninteractive

### Prepare the machine for installation
apt-get update -y && apt-get upgrade -y

### Now install basic packages that can be easily installed by apt-get
apt-get install -y vim openjdk-11-jre-headless openjdk-11-jdk \
zookeeper wget apt-transport-https ca-certificates \
curl gnupg-agent gnupg software-properties-common

### Now Prepare to install logstash
export ELASTICKEY="/usr/share/keyrings/elastic-keyring.gpg"
export ELASTICSRC="https://artifacts.elastic.co/packages/8.x/apt"

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | \
	gpg --dearmor -o "$ELASTICKEY"

echo "deb [signed-by=$ELASTICKEY] $ELASTICSRC stable main" | \
	sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list

### Now install logstash
apt-get update -y
apt-get install -y logstash

### Prepare download directory for non debian package installations
mkdir -p ${DOWNLOAD_DIR}
cd ${DOWNLOAD_DIR}

### Retrieve the Kafka installation image
### wget https://downloads.apache.org/kafka/3.6.0/kafka_2.13-3.6.0.tgz

export BASEURL="https://downloads.apache.org/kafka/"

export KAFKA_BASE=$( curl -s ${BASEURL} | \
        egrep -i "\[DIR\]" | grep -o -E 'href="[^"]+"' | \
        cut -d'"' -f2 | sed 's/\///' | sort -rbn | head -1 )

export KAFKA_FILE=$( curl -s ${BASEURL}/${KAFKA_BASE}/ | \
        egrep -i '\[\s+\]' | egrep -iv '(src|docs).tgz' | \
        grep -o -E 'href="[^"]+"' | cut -d'"' -f2 | sort -rbn | head -1 )

rm -f ${DOWNLOAD_DIR}/${KAFKA_FILE}

wget ${BASEURL}${KAFKA_BASE}/${KAFKA_FILE}

### Unpack and install the installation image
export KAFKAFILE=$( ls -1d kafka*.tgz)

tar -xf $KAFKAFILE

export KAFKADIR=$( basename $KAFKAFILE .tgz )
export KAFKA_BASE_DIR="/usr/local/kafka"
mkdir -p ${KAFKA_BASE_DIR}

export KAFKA_ETC_DIR="/etc/kafka"
mkdir -p ${KAFKA_ETC_DIR}

export KAFKA_SVC_DIR="/etc/systemd/system"
mkdir -p ${KAFKA_SVC_DIR}

export KAFKA_DATA_DIR="/var/data/kafka"
export ZOOKEEPER_DATA_DIR="/var/data/zookeeper"
mkdir -p "${KAFKA_DATA_DIR}" "${ZOOKEEPER_DATA_DIR}"

export KAFKA_LOGS_DIR="/var/log/kafka"
export ZOOKEEPER_LOGS_DIR="/var/log/zookeeper"
mkdir -p "${KAFKA_LOGS_DIR}" "${ZOOKEEPER_LOGS_DIR}"

mv $KAFKADIR/* ${KAFKA_BASE_DIR}

touch ${KAFKA_BASE_DIR}/$KAFKADIR

rm -f ${DOWNLOAD_DIR}/${KAFKA_FILE}

### Setup the appropriate variables for the properties files
export SRC_KAFKA_CFG="$ETCDIR/server.properties"
export SRC_ZOOKEEPER_CFG="$ETCDIR/zookeeper.properties"

export DST_KAFKA_CFG="$KAFKA_ETC_DIR/server.properties"
export DST_ZOOKEEPER_CFG="$KAFKA_ETC_DIR/zookeeper.properties"

### Install the appropriate configuration files
cp ${SRC_KAFKA_CFG} ${DST_KAFKA_CFG}
cp ${SRC_ZOOKEEPER_CFG} ${DST_ZOOKEEPER_CFG}

### Setup the appropriate variables for the Service definition files
export SRC_KAFKA_SVC="$ETCDIR/kafka.service"
export SRC_ZOOKEEPER_SVC="$ETCDIR/zookeeper.service"

export DST_KAFKA_SVC="$KAFKA_SVC_DIR/kafka.service"
export DST_ZOOKEEPER_SVC="$KAFKA_SVC_DIR/zookeeper.service"

### Install the appropriate service definition files
cp ${SRC_KAFKA_SVC} ${DST_KAFKA_SVC}
cp ${SRC_ZOOKEEPER_SVC} ${DST_ZOOKEEPER_SVC}

### Now start the kafka service
systemctl start kafka
systemctl enable kafka
systemctl status kafka | grep -E -i 'Active|PID'

### Now start the zookeeper service
systemctl start zookeeper
systemctl enable zookeeper
systemctl status zookeeper | grep -E -i 'Active|PID'

### Now start the logstash service
systemctl start logstash
systemctl enable logstash
systemctl status logstash | grep -E -i 'Active|PID'
