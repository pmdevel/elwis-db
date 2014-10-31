FROM pmdevel/oracle-xe

MAINTAINER Niclas Ahlstrand <niclas.ahlstrand@pensionsmyndigheten.se>

ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV TMP_DIR /tmp/docker_install_dir

RUN mkdir -p $TMP_DIR

ADD shutdown_db.sh 			$TMP_DIR/
ADD shutdown_db.sql			$TMP_DIR/
ADD change_character_set.sh	$TMP_DIR/
ADD start_stop_tnslistener.sh $TMP_DIR/
RUN chmod 755 				$TMP_DIR/start_stop_tnslistener.sh

RUN echo "export ORACLE_HOME=$ORACLE_HOME" >> /etc/bash.bashrc
RUN echo "export PATH=$ORACLE_HOME/bin:$PATH" >> /etc/bash.bashrc
RUN echo "export ORACLE_SID=XE" >> /etc/bash.bashrc
RUN echo "export NLS_LANG=`$ORACLE_HOME/bin/nls_lang.sh`" >> /etc/bash.bashrc
RUN echo "export ORACLE_BASE=/u01/app/oracle" >> /etc/bash.bashrc
RUN echo "export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH" >> /etc/bash.bashrc

# When declaring VARCHAR2(5) Default to VARCHAR2(5 CHAR) instead of VARCHAR2(5 BYTE)
#RUN ALTER SYSTEM SET NLS_LENGTH_SEMANTICS=CHAR SCOPE=BOTH;

# Start listeners
RUN $TMP_DIR/start_stop_tnslistener.sh start 

# Shutdown db
RUN chmod 755 $TMP_DIR/shutdown_db.sh
RUN $TMP_DIR/shutdown_db.sh

# Change character set
RUN chmod 755 $TMP_DIR/change_character_set.sh
RUN $TMP_DIR/change_character_set.sh WE8ISO8859P15

# Stop listeners
RUN $TMP_DIR/start_stop_tnslistener.sh stop

# Clean-up
RUN rm -rf $TMP_DIR
RUN rm -rf /u01/app/oracle/diag/tnslsnr/*

# Add a "Message of the Day" to help identify container when logging in via SSH
RUN echo '[ Elwis DB with Oracle XE, ISO-8859-15 and WISO schema ]' > /etc/motd

EXPOSE 22
EXPOSE 1521
EXPOSE 8080

CMD sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" $ORACLE_HOME/network/admin/listener.ora; \
    sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" $ORACLE_HOME/network/admin/tnsnames.ora; \
    service oracle-xe start; \
    /usr/sbin/sshd -D

