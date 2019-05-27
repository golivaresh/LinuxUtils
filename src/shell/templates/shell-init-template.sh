# Set the "#! => sha-bang"
# "#!/bin/sh"
# "#!/bin/bash"
# "#!/usr/bin/perl"
# "#!/usr/bin/tcl"
# "#!/bin/sed -f"
# "#!/usr/awk -f"

####################################################################################################
# Aplication: [application name]                                                                   #
# Shell name: [filename].sh                                                                        #
# Description: [brief_description]                                                                 #
# process type: [batch|online]                                                                     #
# Is periodic: [yes|no]                                                                            #
# Every when it executes?: [daily|monthly|by_request...]                                           #
# Dependencies: [yes|no]                                                                           #
#  + List of dependencies: [n/a|list_if_applicable]                                                #
#    - number | dependency name | dependency type                                                  #
# Server where it runs: [hostname|ip] [os]                                                         #
# Estimated time of execution of the process: [0,1...][sec, min, hours...]                         #
# Is it connected to a Database?: [yes|no]                                                         #
#  + SGBD: [oracle|mysql|mongo|...]                                                                #
#  + Instance name: [mydbname]                                                                     #
#  + Database server and port: [hostname|ip]:[port]                                                #
#  + List of objects (tables, procedures, etc.) accessed by the process: [n/a|list_if_applicable]  #
#    - number | object name | object type                                                          #
# Use SFTP?: [yes|no]                                                                              #
#  + List sftp connections: [n/a|list_if_applicable]                                               #
#    - number | [hostname|ip] | port | user connection | keyname                                   #
# Is it Reprocesable?: [yes|no]                                                                    #
#  + Actions to be taken in case of rework: [n/a|list_if_applicable]                               #
#    - number. Actions...                                                                          #
# Receive parameters?: [yes|no]                                                                    #
#  + List of parameters received: [n/a|list_if_applicable]                                         #
#    - Order | parameter name | type | optional | default | comments                               #
# Work with files?: [yes|no]                                                                       #
#  + List of input files: [n/a|list_if_applicable]                                                 #
#    - number | path/filename                                                                      #
# Output files: [yes|no]                                                                           #
#  + List of output files:                                                                         #
#    - number | path/filename | type [data|result|db_spool|sql*loader...]                          #
# Log files: [required]                                                                            #
#  + List of log files:                                                                            #
#    - number | path/filename | type [log|error|info]                                              #
# does it require super user permissions?: [yes|no]                                                #
# Creation:                                                                                        #
#  - Date: [dd/mm/yyyy]                                                                            #
#  - Author:                                                                                       #
#    + Name:                                                                                       #
#    + Company:                                                                                    #
#    + Contact:                                                                                    #
# Modifications:                                                                                   #
#  - number | modification_date | author | company | contact                                       #
####################################################################################################
########################################### ENVIRONMENT ############################################

############################################ PARAMETERS ############################################

############################################ VARIABLES #############################################

############################################ CONSTANTS #############################################
DATE="eval date '+%a %d/%m/%Y %T'"
SUCCESS_CODE=0
ERROR_CODE=1
####################################### LOG PATH - LOG FILE ########################################
LOGFILE="/tmp/log"
LOG="$LOGFILE.log"
LOG_ERROR="$LOGFILE.error"
############################################ FUNCTIONS #############################################

####################################################################################################
# Function: [name]                                                                                 #
# Description:                                                                                     #
# Parameters: [n/a|list_if_applicable]                                                             #
#  + Order | parameter name | type | optional | default | comments                                 #
# Return: [n/a|list_if_applicable]                                                                 #
#  + value | description                                                                           #
####################################################################################################
helloWord() {
    PARAM1=$?
    echo "$PARAM1" >> $LOG 2>> $LOG_ERROR
}

####################################################################################################
#                                      Main - Start ejecution                                      #
####################################################################################################
echo "`$DATE`: Start template..." > $LOG 2> $LOG_ERROR
echo "`$DATE`: Executing function HELLOWORLD..." >> $LOG 2>> $LOG_ERROR
helloWord "Hello World" >> $LOG 2>> $LOG_ERROR
echo "`$DATE`: End template!!" >> $LOG 2>> $LOG_ERROR
