# Docker Presentation
# Hadoop e Vertica

#Immagine di base
FROM ubuntu:18.04 


### HADOOP
ENV HADOOP_HOME /usr/local/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_VERSION 3.2.1

# Installo ssh e openjdk
RUN apt-get update
RUN apt-get install -y --reinstall build-essential
RUN apt-get install -y openjdk-8-jdk 
RUN apt-get install -y nano
RUN apt-get install -y net-tools
RUN apt-get install -y nmap 

#### VERTICA
ENV VERTICA_VERSION 9.3.1

# Install dev tools
RUN apt-get update -y \
&&  apt-get upgrade -y \
&&  apt-get install -y openssh-server \
                       openssh-client \
                       gdb \
                       sysstat \
                       dialog\
                       curl\
					   locales\
					   pstack\
					   iproute2\
&&  apt-get clean

# Set UTF-8 Locale
RUN locale-gen en_US.UTF-8 
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

# Create Vertica user and set default shell to bash, as required by Vertica
RUN groupadd -r verticadba \
&&  useradd -r -m -g verticadba dbadmin \
&&  chsh -s /bin/bash dbadmin \
&&  chsh -s /bin/bash root \
&&  rm /bin/sh \
&&  ln -s /bin/bash /bin/sh

ENV SHELL "/bin/bash"

# Copy Vertica deb installers
# Vertica va scaricato in locale dopo essersi registrati
RUN mkdir -p /srv/setup
COPY software/vertica-console_9.3.0-0_amd64.deb /srv/setup
COPY software/vertica_9.3.0-0_amd64.deb /srv/setup

# Pre-installation steps
# Disable Transparent Hugepages
RUN echo "kernel/mm/transparent_hugepage/enabled = never" >> /etc/sysfs.conf
# Create Vertica data and Swap folders
RUN mkdir -p /srv/vertica/db
RUN mkdir -p /swap

# Install Vertica
# dpfg utilizzato per installare, disinstallare, ottenere informazioni su pacchetti .deb
RUN dpkg -i /srv/setup/vertica_9.3.0-0_amd64.deb

# To complete your NEW installation and configure the cluster, run: /opt/vertica/sbin/install_vertica
RUN /opt/vertica/sbin/install_vertica \
        --license CE \
        --accept-eula \
        --hosts localhost  \
        --deb /srv/setup/vertica_9.3.0-0_amd64.deb \
        --data-dir /srv/vertica/db \
        --dba-user dbadmin \
        --failure-threshold NONE

# Install Vertica Console
RUN dpkg -i /srv/setup/vertica-console_9.3.0-0_amd64.deb

# Remove setup files
RUN rm /srv/setup/vertica-console_9.3.0-0_amd64.deb
RUN rm /srv/setup/vertica_9.3.0-0_amd64.deb
RUN rm -R /srv/setup

# Replace bootstrap with new version 
COPY bootstrap.sh /etc/
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh


CMD [ "sh", "-c", "service ssh start; bash"]

# Expose ports
# Vertica
EXPOSE 5433
EXPOSE 5450

