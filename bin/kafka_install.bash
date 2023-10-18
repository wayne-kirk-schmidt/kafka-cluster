#!/usr/bin/env bash

### Set up basic path and permissions to assist the script
umask 022
export PATH="/usr/bin:/usr/local/bin:/sbin:/usr/sbin:$PATH"

### Setup apt-get and following scripts to be non-interactive
export DEBIAN_FRONTEND=noninteractive

### Prepare the machine for installation
apt-get update -y && apt-get upgrade -y

### Now install basic packages that can be easily installed by apt-get
apt-get install -y vim openjdk-11-jre-headless openjdk-11-jdk \
zookeeper wget apt-transport-https ca-certificates \
curl gnupg-agent gnupg software-properties-common logstash

### Create and download directory
export DOWNLOAD_DIR="/var/tmp/downloads"

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

wget ${BASEURL}${KAFKA_BASE}/${KAFKA_FILE}

### Unpack and install the installation image
export KAFKAFILE=$( ls -1d kafka*.tgz)

tar -xvf $KAFKAFILE

export KAFKADIR=$( basename $KAFKAFILE .tgz )
export KAFKA_BASE_DIR="/usr/local/kafka"

mkdir -p ${KAFKA_BASE_DIR}

mv $KAFKADIR/* ${KAFKA_BASE_DIR}
touch ${KAFKA_BASE_DIR}/$KAFKADIR

### Define the bin and the etc directory as related to the running script
export BINDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
export ETCDIR=$( realpath $BINDIR/../etc )

### Setup the appropriate variables for the properties files
export SRC_KAFKA_CFG="$ETCDIR/server.properties"
export SRC_ZOOKEEPER_CFG="$ETCDIR/zookeeper.properties"

export DST_KAFKA_CFG="/etc/kafka/server.properties"
export DST_ZOOKEEPER_CFG="/etc/kafka/zookeeper.properties"

### Install the appropriate configuration files
cp ${SRC_KAFKA_CFG} ${DST_KAFKA_CFG}
cp ${SRC_ZOOKEEPER_CFG} ${DST_ZOOKEEPER_CFG}

### Setup the appropriate variables for the Service definition files
export SRC_KAFKA_SVC="$ETCDIR/kafka.service"
export SRC_ZOOKEEPER_SVC="$ETCDIR/zookeeper.service"

export DST_KAFKA_SVC="/etc/kafka/kafka.service"
export DST_ZOOKEEPER_SVC="/etc/kafka/zookeeper.service"

### Install the appropriate service definition files
cp ${SRC_KAFKA_SVC} ${DST_KAFKA_SVC}
cp ${SRC_ZOOKEEPER_SVC} ${DST_ZOOKEEPER_SVC}

### Now start the kafka service
systemctl start kafka
systemctl enable kafka
systemctl status kafka

### Now start the zookeeper service
systemctl start zookeeper
systemctl enable zookeeper
systemctl status zookeeper
