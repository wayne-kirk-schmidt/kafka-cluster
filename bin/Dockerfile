# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Update the package lists
RUN apt-get update -y && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y \
    wget \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    git 

RUN git clone https://github.com/wayne-kirk-schmidt/kafka-tools.git /var/tmp

# Set the working directory to the cloned repository
WORKDIR /var/tmp/kafka-tools/bin

# Run the shell script (replace "build-script.sh" with your actual script name)
RUN chmod 755 ./kafka_install.bash && ls -la ./kafka_install.bash

# Expose Kafka and Zookeeper ports
EXPOSE 9093 9092 2181
