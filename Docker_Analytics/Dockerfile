# Docker Analytics
# Hadoop, Hive e Jupyter

# Immagine di base
FROM ubuntu:18.04

ENV HADOOP_HOME /usr/local/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_VERSION 3.2.1


# Create HDFS folder
RUN mkdir -p /srv/hadoop/hdfs/datanode && \
    mkdir -p /srv/hadoop/hdfs/namenode

# Pre-Installation Steps:	
# Installo ssh e openjdk
RUN apt-get update && \
    apt-get install -y openssh-server
	
RUN apt-get update
RUN apt-get install -y --reinstall build-essential
RUN apt-get install -y vim 
RUN apt-get install -y openjdk-8-jdk 
RUN apt-get install -y nano
RUN apt-get install -y net-tools
RUN apt-get install -y nmap
RUN apt-get install -y unzip
RUN apt-get install -y telnet

# Installo hadoop
# Se Hadoop non è installato localmente, decommentare le prossime due righe...
# RUN wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
# tar -xzvf hadoop-${HADOOP_VERSION}.tar.gz && \

# ...E commentare questa
ADD hadoop-3.2.1.tar.gz /  
RUN mv hadoop-3.2.1 $HADOOP_HOME && \
    echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc


# Config Hadoop file
ADD core-site.xml $HADOOP_HOME/etc/hadoop/
ADD hdfs-site.xml $HADOOP_HOME/etc/hadoop/

RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
# Add localhost and 0.0.0.0 to known hosts
RUN ssh-keyscan -H 127.0.0.1 >> ~/.ssh/known_hosts
RUN ssh-keyscan -H 0.0.0.0 >> ~/.ssh/known_hosts


# WORKDIR /

# Download and Init Hive
# Se Hive non è installato localmente, decommentare la prossima riga...
# RUN wget https://mirror.nohup.it/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz | tar -zx -C /usr/local
#... E commentare questa
ADD apache-hive-3.1.2-bin.tar.gz /usr/local 
ENV PATH /usr/local/apache-hive-3.1.2-bin/bin:$PATH

#Config Hive file
ADD hive-site.xml /usr/local/apache-hive-3.1.2-bin/conf/
ADD hive-env.sh /usr/local/apache-hive-3.1.2-bin/conf

RUN rm /usr/local/apache-hive-3.1.2-bin/lib/guava-19.0.jar
RUN cp /usr/local/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar /usr/local/apache-hive-3.1.2-bin/lib/

############## JUPYTER #######################à
# installo python, pip e python virtual environment 
RUN apt-get update --fix-missing \
    && apt-get install -y wget bzip2 ca-certificates git python3.6 python3.6-venv python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip

#Installo requisiti per pyhive
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install -y libsasl2-dev

#Installo jupyter e librerie riportate nel file requirements
COPY requirements.txt /
RUN pip install -U jupyter
RUN pip install -r requirements.txt


################ CONFIG HADOOP NAMENODE ###################
RUN /usr/local/hadoop/bin/hdfs namenode -format


# Replace bootstrap with new version 
COPY bootstrap.sh /etc/
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

CMD ["sh", "-c", "service ssh start; bash"]


# Expose Ports
# Hive
EXPOSE 10000
EXPOSE 10002
# Jupyter
EXPOSE 8888 
# Hadoop
EXPOSE 8080
EXPOSE 8030
EXPOSE 8032
EXPOSE 9000
EXPOSE 50070 
EXPOSE 50075 
EXPOSE 50090 
EXPOSE 50100
