# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Update the package lists
RUN apt-get update -y && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y \
    openjdk-11-jre-headless \
    zookeeperd \
    wget \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    python3.11 \
    python3-pip

# Install Docker using apt-get
RUN apt-get install -y docker.io

# Install Kafka
RUN wget https://downloads.apache.org/kafka/2.8.0/kafka_2.13-2.8.0.tgz && \
    tar -xzf kafka_2.13-2.8.0.tgz && \
    mv kafka_2.13-2.8.0 /opt/kafka && \
    rm kafka_2.13-2.8.0.tgz

# Install Logstash
RUN wget https://artifacts.elastic.co/downloads/logstash/logstash-7.15.2-amd64.deb && \
    dpkg -i logstash-7.15.2-amd64.deb && \
    rm logstash-7.15.2-amd64.deb

# Set environment variables for Kafka and Zookeeper
ENV KAFKA_HOME /opt/kafka
ENV PATH $PATH:$KAFKA_HOME/bin
ENV ZOOKEEPER_HOME /usr/share/zookeeper
ENV PATH $PATH:$ZOOKEEPER_HOME/bin

# Expose Kafka and Zookeeper ports
EXPOSE 9093 9092 2181

# Start Zookeeper and Kafka
CMD service zookeeper start && kafka-server-start.sh $KAFKA_HOME/config/server.properties
