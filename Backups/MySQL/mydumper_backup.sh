#!/bin/bash - 
#===============================================================================
#
#          FILE: mydumper_backup.sh
# 
#         USAGE: ./mydumper_backup.sh 
# 
#   DESCRIPTION: Manage MySQL backups using mydumper
# 
#       OPTIONS: ---
#  REQUIREMENTS: mydumper
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com), 
#  ORGANIZATION: 
#       CREATED: 04/19/2021 22:47
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

function write_log () {
  logger --tag mydumper_backup "$@" 
}

function report_error () {
>&2 echo "$@"
}

function check_mydumper () {
dpkg -s mydumper 2> /dev/null > /dev/null
is_not_installed=$?

if (( $is_not_installed != 0 )); then
report_error "mydumper is not installed."
exit 1
fi
}

function check_backup_folder (){
        [[ -v BACKUPP_FOLDER ]]; backup_folder_is_defined=$?
        if (( $backup_folder_is_defined != 0 )); then
BACKUPP_FOLDER="/mnt/mysql/backup"
        fi
}

function create_backup_folder (){
        [[ -v BACKUPP_FOLDER ]]; backup_folder_is_defined=$?
        if (( $backup_folder_is_defined != 0 )); then
BACKUPP_FOLDER="/mnt/mysql/backup"
        fi
}

##########
## Main ##
##########

 check_mydumper
 check_backup_folder

 create_backup_folder
 echo ${BACKUPP_FOLDER}
