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

function set_retain_days (){
        [[ -v BACKUP_RETAIN_DAYS ]]; backup_retain_days_is_defined=$?
        if (( $backup_retain_days_is_defined != 0 )); then
BACKUP_RETAIN_DAYS="8"
        fi
}


function create_backup_folder (){
        mkdir -p ${BACKUPP_FOLDER}
        backup_folder_has_been_created=$?
        if (( $backup_folder_has_been_created != 0 )); then
exit 1
        fi
}

function perform_backup (){
        backup_folder_name=$(date +'%Y_%m_%d')
        test -d "${BACKUPP_FOLDER}/${backup_folder_name}"; backup_folder_already_exists=$? 
        if (( $backup_folder_already_exists == 0 )); then
                report_error "${BACKUPP_FOLDER}/${backup_folder_name} already exists."
                exit 1
        else
        mydumper --outputdir "${BACKUPP_FOLDER}/${backup_folder_name}" --lock-all-tables --compress
        backup_has_been_succeeded=$?
        if (( $backup_has_been_succeeded != 0 )); then
exit 1
        fi
        fi
}

function remove_old_backups (){
        find ${BACKUPP_FOLDER} -mindepth 1 -maxdepth 1  -daystart -mtime +${BACKUP_RETAIN_DAYS} -delete
        delete_error=$? 
        if (( $delete_error != 0 )); then
exit 1
        fi
}


##########
## Main ##
##########

 check_mydumper
 check_backup_folder
 set_retain_days

 create_backup_folder
 perform_backup

 remove_old_backups
