#!/bin/bash
####################################################################################################
# Aplication: Docker File for Custom centos 7 image.                                               #
# Shell name: createUser.sh                                                                        #
# Description: This process create a default user for the builded "docker container".              #
# process type: batch                                                                              #
# Is periodic: no                                                                                  #
# Every when it executes?: by request                                                              #
# Dependencies: n/a                                                                                #
#  + List of dependencies: n/a                                                                     #
#    - number | dependency name | dependency type                                                  #
# Server where it runs: docker container                                                           #
# Estimated time of execution of the process: 5 seconds                                            #
# Is it connected to a Database?: no                                                               #
#  + SGBD: n/a                                                                                     #
#  + Instance name: n/a                                                                            #
#  + Database server and port: n/a                                                                 #
#  + List of objects (tables, procedures, etc.) accessed by the process: n/a                       #
#    - number | object name | object type                                                          #
# Use SFTP?: no                                                                                    #
#  + List sftp connections: n/a                                                                    #
#    - number | [hostname|ip] | port | user connection | keyname                                   #
# Is it Reprocesable?: yes                                                                         #
#  + Actions to be taken in case of rework: n/a                                                    #
#    - number. Actions...                                                                          #
# Receive parameters?: yes                                                                         #
#  + List of parameters received:                                                                  #
#    - Order | parameter name    | type | optional | default | comments                            #
#    - 01    | USER              | text | no       |                                               #
#    - 02    | USERDESC          | text | no       |                                               #
#    - 03    | ADITIONALS_GROUPS | text | yes      | ""      | separate by ; (without spaces)      #
# Work with files?: no                                                                             #
#  + List of input files: n/a                                                                      #
#    - number | path/filename                                                                      #
# Output files: no                                                                                 #
#  + List of output files:                                                                         #
#    - number | path/filename | type [data|result|db_spool|sql*loader...]                          #
# Log files: [required] No, porque es un shell de configuración.                                   #
#  + List of log files:                                                                            #
#    - number | path/filename | type [log|error|info]                                              #
# does it require super user permissions?: yes                                                     #
# Creation:                                                                                        #
#  - Date:  24/05/2019                                                                             #
#  - Author:                                                                                       #
#    + Name: Gustavo Olivares Hernández - golivaresh                                               #
#    + Company: golivaresh                                                                         #
#    + Contact: gustavo.oh@outlook.es                                                              #
# Modifications:                                                                                   #
#  - number | modification_date | author | company | contact                                       #
####################################################################################################
########################################### ENVIRONMENT ############################################
WORKING_DIRECTORY=$(pwd)
PROCESS="createUser"
SHELL="$PROCESS".sh
############################################ PARAMETERS ############################################
# User to add.
USER=$1
# Description of user.
USERDESC=$2
# Aditionals groups for add to user.
ADITIONALS_GROUPS=$3
############################################ VARIABLES #############################################
# Aditionals groups added correctly (if something goes wrong, these groups will be removed).
additionalGroupsAdded=""
# All Additional groups will be added to the user.
additionalAllGroupsToAdd=""
############################################ CONSTANTS #############################################
# File to save the password for the user.
PWD_FILE="/tmp/passwd"
# Date of log.
DATE="eval date '+%a %d/%m/%Y %T'"
# Success code
SUCCESS_CODE=0
# Error code
ERROR_CODE=1
####################################### LOG PATH - LOG FILE ########################################
# Base name of the log file.
LOGFILE="$WORKING_DIRECTORY/log"
# Name of the log file.
LOG="$LOGFILE.log"
# Name of the error log file.
LOG_ERROR="$LOGFILE.error"
############################################ FUNCTIONS #############################################

####################################################################################################
# Function: validateUser                                                                           #
# Description: Validate if the user exists. If the case is true: this process ends.                #
# Parameters:                                                                                      #
#  + Order | parameter name | type | optional | default | comments                                 #
#    01    | userToValidate | text | no       | n/a     | User to validate.                        #
# Return: n/a                                                                                      #
####################################################################################################
validateUser() {
    userToValidate=$1
    echo "$($DATE): validating user [$userToValidate]..."
    if [ -n "$userToValidate" ] ; then
		id "$userToValidate"
		resp=$?
		if [ "$resp" -eq 0 ] ; then
		    echo "The user [$userToValidate] exists, the process can not continue!"
			exit $ERROR_CODE
		else
		    echo "$($DATE): User to add [$userToValidate]..."
		fi
    else
        echo "$($DATE): Unspecified user!"
        exit $ERROR_CODE
    fi
}

####################################################################################################
# Function: addGroups                                                                              #
# Description: Create an additional group for the user to add.                                     #
# Parameters: n/a                                                                                  #
#  + Order | parameter name | type | optional | default | comments                                 #
#    01    | groupsToAdd    | text | no       | n/a     | groups to add, separate by ';'.          #
# Return:                                                                                          #
#  + 0 | agreate groups correctly                                                                  #
####################################################################################################
addGroups() {
    groupsToAdd=$1
    if [ -n "$groupsToAdd" ] ; then
       echo "$($DATE): Starting addGroup..."
       
	   IFS=',' read -ra ADDR <<< "$groupsToAdd"
       echo "$($DATE): Groups have been found!"
       let countAditionalsAdded=0
	   let countAllAditionalsToAdd=0
	   for i in "${ADDR[@]}"; do
            existGroup=$(grep "$i" /etc/group | wc -l)
            if [ "$existGroup" -le 0 ] ; then 
		        echo "$($DATE): This aditional group: [$i] not exists!, creating group..."
                groupadd $i ##################
                resp=$?
                if [ "$resp" -eq "$SUCCESS_CODE" ] ; then
				    additionalGroupsAdded[$countAditionalsAdded]="$i"
					additionalAllGroupsToAdd[$countAllAditionalsToAdd]="$i"
					countAditionalsAdded=$((countAditionalsAdded + 1))
					additionalAllGroupsToAdd[$countAllAditionalsToAdd]="$i"
                    echo "$($DATE): Aditional group: [$i] has been added correctly!"
                else
                    echo "$($DATE): An error ocurred while add $i"
                fi
            else
                echo "$($DATE): This aditional group: [$i] exists!"
				additionalAllGroupsToAdd[$countAllAditionalsToAdd]="$i"
            fi
			countAllAditionalsToAdd=$((countAllAditionalsToAdd + 1))
       done
	   echo "$($DATE): [$countAditionalsAdded] groups were added correctly"
    else
        echo "$($DATE): The ADDITIONAL_GROUPS have not been specified."
    fi
    return $SUCCESS_CODE
}

####################################################################################################
# Function: removeGroups                                                                           #
# Description: Remove the aditional groups created by the "addGroups" function                     #
# Parameters: n/a                                                                                  #
#  + Order | parameter name | type | optional | default | comments                                 #
#    01    | groupsToRemove | text | no       | n/a     | groups to remove, separate by ';'.       #
# Return: n/a                                                                                      #
####################################################################################################
removeGroups() {
    groupsToRemove=$1
    echo "$($DATE): Removing groups $groupsToRemove..."
	if [ -n "$groupsToRemove" ] ; then
		IFS=';' read -ra ADDR <<< "$groupsToRemove"
        echo "$($DATE): Aditional Groups have been found!"
        for i in "${ADDR[@]}"; do
		    groupdel "$i"
			resp=$?
			if [ "$resp" -eq "$SUCCESS_CODE" ] ; then
                echo "$($DATE): Aditional group: [$i] has been removed correctly!"
            else
                echo "$($DATE): An error ocurred while remove $i."
            fi
	    done
		echo "Please validate groups, after completing this process."
	else
	    echo "$($DATE): There are no groups to remove!"
	fi
}

####################################################################################################
# Function: addUser                                                                                #
# Description: Create the specified user and their additional groups.                              #
# Parameters:                                                                                      #
#  + Order | parameter name         | type | optional | default | comments                         #
#    01    | userToAdd              | text | no       | n/a     | User to add.                     #
#    02    | userDescription        | text | no       | n/a     | Description of the user          #
#                                                                 (empty if it does not require    #
#                                                                   this field).                   #
#    03    | aditionalsGroupsToUser | text | no       | n/a     | groups to add, separate by ','   #
#                                                                 (empty if it does not require    #
#                                                                   additional groups).            #
# Return:                                                                                          #
#  + 0 | Agregate user correctly.                                                                  #
#  + 1 | A error ocurred at the add the user.                                                      #
####################################################################################################
addUser() {
    userToAdd=$1
	userDescription=$2
    aditionalsGroupsToUser=$3
	echo "$($DATE): User to add: $userToAdd $userDescription"
	echo "$($DATE): Principal group to add: $userToAdd"
	echo "$($DATE): Aditional groups to add: $aditionalsGroupsToUser"
    useradd -c "$userDescription" -U -G "$aditionalsGroupsToUser" -m -s /bin/bash "$userToAdd" ##################
    resp=$?
    if [ "$resp" -eq 0 ] ; then
        echo "$($DATE): User [$userToAdd] has been added correctly!"
        echo "$($DATE): Welcome $userToAdd, a random password is added..."   
        echo `uuidgen` > $PWD_FILE
        echo -e "$(cat $PWD_FILE)\n$(cat $PWD_FILE)" | passwd "$userToAdd"  ##################
        resp=$?
        if [ "$resp" -eq 0 ] ; then
            echo "$($DATE): The password for $userToAdd has been added correctly!"
            echo "$($DATE): The password is `cat $PWD_FILE`"
        else
            echo "$($DATE):An error ocurred while add passwd"
        fi
        echo "$($DATE): It is recommended to change or configure the password immediately!"
        rm $PWD_FILE
        return $SUCCESS_CODE
    else
       echo "$($DATE): An error ocurred while add $userToAdd!"
    fi
    return $ERROR_CODE
}

####################################################################################################
#                                      Main - Start ejecution                                      #
####################################################################################################
# >> $LOG 2>> $LOG_ERROR
echo "$($DATE): Start $SHELL..." 

# validate user
validateUser "$USER"

# add groups
echo "$($DATE): Executing function addGroups..." 
addGroups "$ADITIONALS_GROUPS"
resp=$?
echo "$($DATE): addGroups: [$resp]"
if [ "$resp" != "$SUCCESS_CODE" ] ; then
    echo "$($DATE): Error adding groups, can not continue!"
	removeGroups "$(echo ${additionalGroupsAdded[*]} | tr ' ' ';')"
    exit $ERROR_CODE
fi

# add user
addUser "$USER" "$USERDESC" "$(echo ${additionalAllGroupsToAdd[*]} | tr ' ' ',')"
resp=$?
echo "$($DATE): addUser: [$resp]"
if [ "$resp" != "$SUCCESS_CODE" ] ; then
    echo "$($DATE): Error adding user, can not continue!"
	removeGroups "$(echo ${additionalGroupsAdded[*]} | tr ' ' ';')"
    exit $ERROR_CODE
fi

echo "$($DATE): End $SHELL!" 