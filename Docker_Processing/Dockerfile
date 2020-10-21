# Docker Processing
# Hadoop e spark

# Immagine di base
FROM ubuntu:18.04

ENV HADOOP_HOME /usr/local/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV SPARK_VERSION 2.4.5
ENV SPARK_HOME=/usr/local/spark

RUN apt-get update
RUN apt-get install -y nano
RUN apt-get install -y net-tools
RUN apt-get install -y nmap
#RUN apt-get install -y openssh-server
#RUN apt-get install -y openssh-client

# Install Java
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk 

# Install python
RUN apt-get update --fix-missing \
    && apt-get install -y wget bzip2 ca-certificates git python3.6 python3.6-venv python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip

# Install Spark
# Se spark non è presente in locale, decommentare la prossime riga...
# RUN wget http://apache.mirror.anlx.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz
# ... e commentare questa
COPY spark-${SPARK_VERSION}-bin-without-hadoop.tgz /
RUN tar -xzvf spark-${SPARK_VERSION}-bin-without-hadoop.tgz -C /usr/local/
RUN mv /usr/local/spark-${SPARK_VERSION}-bin-without-hadoop /usr/local/spark && \
	echo "export PYSPARK_PYTHON=python3" >> ~/.bashrc

RUN rm /spark-${SPARK_VERSION}-bin-without-hadoop.tgz

# Librerie hadoop
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH

ADD spark-env.sh /usr/local/spark/conf/
RUN echo "spark.hadoop.dfs.client.use.datanode.hostname true" >> /usr/local/spark/conf/spark-defaults.conf


#CMD [ "sh", "-c", "service ssh start; bash"]
# Spark
EXPOSE 2222
EXPOSE 8080
