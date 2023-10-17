Kafka Build
===========

Kafka looks to build a kafka and zookeeper cluster, using docker as the implementation engine.

The installation consists of two stages:

*   bash scripts that can be included into a build process (VMware, Terraform, Ansible, etc. ) to install docket.

*   ensure that local users have docker privileges and the home directy of the user contains a docker-compose.yml file.

*   from the docker-compose.yml file, install the docker image, ensuring that any finishing scripts are run via docker.

Installing the Scripts
=======================

The scripts are designed to be used within a batch script or DevOPs tool.

Where possible, the scripts use bash, and will not rely on any more sophisticated tools.

There are python based client tools for kafka, though they are to manage topics, groups, and partitions.

To install python into the build if not already installed, please perform the following steps:


    1. Download and install python 3.6 or higher from python.org. Append python3 to the LIB and PATH env.

    2. Download and install git for your platform if you don't already have it installed.
       It can be downloaded from https://git-scm.com/downloads
    
    3. Open a new shell/command prompt. It must be new since only a new shell will include the new python 
       path that was created in step 1. Change to the folder where you want to install the scripts.
    
    4. Execute the following command to install pipenv, which will manage all of the library dependencies:
    
        sudo -H pip3 install pipenv 
 
    5. Clone this repository. This will create a new folder
    
    6. Change into this folder. Type the following to install all the package dependencies 
       (this may take a while as this will download all of the libraries it uses):

        pipenv install
        
Dependencies
============

See the contents of "pipfile"

Script Names and Purposes
=========================

The scripts are organized into sub directories:

    1. ./bin - has all of the scripts here

    2. ./doc - this has reference information including sample emojis 

    3. ./etc - this contains any specific configuration files required for installation

Examples
========

To Do List:
===========

*    no current backlog of features as of present

License
=======

Copyright 2023 

* Wayne Kirk Schmidt (wayne.kirk.schmidt@changeis.co.jp)

Licensed under the Apache 2.0 License (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    license-name   Apache 2.0 
    license-url    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Support
=======

Feel free to e-mail me with issues to: 

+   wayne.kirk.schmnidt@gmail.com

*   wayne.kirk.schmidt@changeis.co.jp

I will provide "best effort" fixes and extend the scripts.
