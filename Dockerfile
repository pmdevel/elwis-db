FROM pmdevel/oracle-xe

MAINTAINER Niclas Ahlstrand <niclas.ahlstrand@pensionsmyndigheten.se>

ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV TMP_DIR /tmp/docker_install_dir

RUN mkdir -p $TMP_DIR

RUN echo "export ORACLE_HOME=$ORACLE_HOME" >> /etc/bash.bashrc
RUN echo "export PATH=$ORACLE_HOME/bin:$PATH" >> /etc/bash.bashrc
RUN echo "export ORACLE_SID=XE" >> /etc/bash.bashrc
RUN echo "export NLS_LANG=`$ORACLE_HOME/bin/nls_lang.sh`" >> /etc/bash.bashrc
RUN echo "export ORACLE_BASE=/u01/app/oracle" >> /etc/bash.bashrc
RUN echo "export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH" >> /etc/bash.bashrc

# Clean-up
RUN rm -rf $TMP_DIR

# Add a "Message of the Day" to help identify container when logging in via SSH
RUN echo '[ Elwis DB with Oracle XE with WISO schema ]' > /etc/motd

EXPOSE 1521
EXPOSE 8080

CMD sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" $ORACLE_HOME/network/admin/listener.ora; \
    sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" $ORACLE_HOME/network/admin/tnsnames.ora; \
    service oracle-xe start;

