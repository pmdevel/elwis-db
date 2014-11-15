#!/bin/bash

su -l -c "cp /tmp/docker_install_dir/create_wiso_schema.sql /u01/app/oracle/ " oracle
su -l -c "source $ORACLE_HOME/bin/oracle_env.sh; sqlplus / as sysdba @WISO" oracle
