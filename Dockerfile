FROM openjdk:8
MAINTAINER greggentling https://github.com/greggentling

ENV PENTAHO_HOME /opt/pentaho


RUN . /etc/environment
ENV JAVA_HOME /usr/local/openjdk-8
ENV PENTAHO_JAVA_HOME /usr/local/openjdk-8

# Install Dependences
RUN apt-get update; apt-get install zip netcat postgresql-client -y; \
    apt-get install wget unzip git vim cron libwebkitgtk-1.0-0 -y; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir ${PENTAHO_HOME}; useradd -s /bin/bash -d ${PENTAHO_HOME} pentaho; chown pentaho:pentaho ${PENTAHO_HOME}

RUN mkdir /work

VOLUME /etc/cron.d
VOLUME /work

RUN wget --progress=dot:giga https://downloads.sourceforge.net/project/pentaho/Pentaho%208.2/server/pentaho-server-ce-8.2.0.0-342.zip -O /tmp/pentaho-server.zip 
RUN /usr/bin/unzip -q /tmp/pentaho-server.zip -d  $PENTAHO_HOME; \
    rm -f /tmp/pentaho-server.zip; 
RUN rm -f /opt/pentaho/pentaho-server/promptuser.sh


EXPOSE 8080

COPY run_pentaho_server.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run_pentaho_server.sh
CMD /usr/local/bin/run_pentaho_server.sh
