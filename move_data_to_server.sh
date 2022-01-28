#!/bin/bash

##
# Check to make sure that all arguments are present
if [ ! $# -eq 0 ] ; then
  echo 'Usage: $ sh <move_data_to_server.sh>'  
  exit 0
fi 


#****************Input paramters***************#
# need to replace with real path
#files_path_='/home/
f_path=`echo /home/`
files_path="${f_path}"

f_name="all_files_.txt"  
# creates a text file in current directory for later use
#**********************************************#.


output=$(expect -c '


set mrl "192.168.1.1"
set user_name "user"
set password "abc"

spawn ssh $user_name@$mrl
sleep 1
expect "password:"
send "$password\r"
expect "Last login"
send "cd Desktop\r"
expect "$"
;#send "exit\r"
;#expect "logout"
#close
interact
')


: << --
if [ "$(ls -A $files_path)" ]; then
  echo "Directory is not Empty"
  dir_size1=`du $files_path | awk '{print $1}'`
  sleep 1
  dir_size2=`du $files_path | awk '{print $1}'`
  # size of file is constant
  if [ "${dir_size1}" = "${dir_size2}" ] ; then
	ls -l $files_path > $f_name
	while read line
	do
	month_=`echo $line | cut -d' ' -f6`
	date_=`echo $line | cut -d' ' -f7`
	time_=`echo $line | cut -d' ' -f8`
	hr_=`echo $time_ | awk -F: '{print $1}'`
	min_=`echo $time_ | awk -F: '{print $2}'`
	echo $month_ $date_ $hr_ $min_
	done < $f_name
  else
	echo "Directory size is increasing"
  fi
else
  echo "Directory is Empty"
fi
--
