#!/bin/bash


# Check to make sure that all arguments are present
if [ ! $# -eq 3 ] ; then
  echo 'Usage: $ sh <move_data_client.sh> <username_server> <password_server> <ip_server>'  
  exit 0
fi 

#*************Modifiable paramters**************#
# need to replace with real path
f_name="all_files_.txt"  

# path of files on client system
user_name=`whoami`
files_path_videos="/home/$user_name/Desktop/MM1 Capture"


files_path_html="/home/$user_name/Desktop/html"


server_name=$1
server_pass=$2
server_ip=$3

# path where move file to
#destination_path_firm="/home/$user_name/ROOTPEGASUS"
destination_path_firm="/home/$user_name/ROOTPEGASUS"


# creates a text file in current directory for later use
#**********************************************#
count=0
for path in "${files_path_videos}" "${files_path_html}"
do 

#path="${path}"

if [ $count -eq 0 ]
then
  path_last="Videos"
else
  path_last="HTML"
fi


# to check directory is not empty
if [ "$(ls -A "${path}")" ]; then
  echo "Directory is not Empty"

  dir_size1=`du "${path}" | awk '{print $1}'`
  sleep 2
  dir_size2=`du "${path}" | awk '{print $1}'`

  # size of file is constant
  if [ "${dir_size1}" = "${dir_size2}" ] ; then
	ls --full-time "${path}" > $f_name
	# f_name contains information of STpkg and html files
	# in each loop seperately

	while read line
	do
	

	#$file_name contains the name of each file
	file_name=`echo $line | cut -d' ' -f9`
	ext="$(echo $line | cut -d' ' -f10)"
	if [ ! "$ext" = "" ]
	then
	file_name=$file_name" "$ext
	fi

	full_time_=`echo $line | cut -d' ' -f6`
	time_=`echo $line | cut -d' ' -f7`

	year_=`echo $full_time_ | awk -F'-' '{print $1}'`
	month_=`echo $full_time_ | awk -F'-' '{print $2}'`
	date_=`echo $full_time_ | awk -F'-' '{print $3}'`

	hr_=`echo $time_ | awk -F: '{print $1}'`
	min_=`echo $time_ | awk -F: '{print $2}'`
	#echo $year_ $month_ $date_ $hr_ $min_

	# to make sure date is in two digits 
	if [ ${#date_} -eq 1 ]
	then
	date_="0$date_"
	fi

	# Forming complete names for all months to make directories
	# having same names as newly created names
	if [ "$month_" = "01" ]
	then
	  month_full_name='January'
	elif [ "$month" = '02' ]; then
	  month_full_name='February'
	elif [ "$month_" = '03' ]; then
	  month_full_name='March'
	elif [ "$month_" = '04' ]; then
	  month_full_name='April'
	elif [ "$month_" = '05' ]; then
	  month_full_name='May'
	elif [ "$month_" = '06' ]; then
	  month_full_name='June'
	elif [ "$month_" = '07' ]; then
	  month_full_name='July'
	elif [ "$month_" = '08' ]; then
	  month_full_name='August'
	elif [ "$month_" = '09' ]; then
	  month_full_name='September'
	elif [ "$month_" = '10' ]; then
	  month_full_name='October'
	elif [ "$month_" = '11' ]; then
	  month_full_name='November'
	elif [ "$month_" = '12' ]; then
	  month_full_name='December'
	fi  # to complete full spelling of month

	# To make hour 09 into 9 , i.e one digit
	# two didgit 11 will remain as it is  
	s=$hr_
	b=${s:0:1}
	if [ "${b}" = "0" ]
	then
	  hr_=${s:1:1}
	fi
	# check day time each day

	if [ $((hr_)) -ge 0 -a $((hr_)) -le 12 ]
	then
	  day_time='Morning'
	else
	  day_time='Afternoon'
	fi

	#echo $month_full_name $date_ $hr_ $min_
	
	# length of year is greater than 2
	# to make sure file exists
	if [ ${#year_} -ge 2 ]
	then

	# Run expect script to move files to server
	file_path=$path

	#file_path_new="$(echo $file_path | sed 's/ /\\ /')"
	file_path_new=$file_path/$file_name
	#file_path_new=\"$file_path_new\"

	# path of destination folder on server
	destination_path_new=$destination_path_firm/$year_/$month_full_name/$date_/$day_time/$path_last
	#destination_path_new="$(echo $destination_path_new | sed 's/ /\\ /')"
	destination_path_new=\"$destination_path_new\"


	
	# Run expect script to create a destination folder of it does not exist
	#****************************************
	#expect script_client_for_exisitng_files.exp "${server_name}" "${server_pass}" "${server_ip}" "${destination_path_new}"
	#****************************************


	
	echo "file_path:"$file_path_new
	echo "destpath"$destination_path_new
	#scp -r $file_path_new $server_name@$server_ip:$destination_path
	expect script_client.exp "${server_name}" "${server_pass}" "${server_ip}" "${file_path_new}" "${destination_path_new}"
	#expect new.exp


	fi  # year length is greater than 1

	done < $f_name

	#rm -rf $path/*


  else
	echo "Directory size is increasing"
  fi # directory size is not changing
else
  echo "Directory is Empty"
fi # directory is empty

count=`expr $count \+ 1`
done # loop for both directories
