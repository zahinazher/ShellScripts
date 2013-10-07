#!/bin/bash


# Check to make sure that all arguments are present
if [ ! $# -eq 0 ] ; then
  echo 'Usage: $ sh filename.sh'  
  exit 0
fi 

user_name=`whoami`
#****************Input paramters***************#
# path to create folders on server
root_path="/home/$user_name/ROOTPEGASUS/"  # need to replace with real path
#root_path="${root_path}"

# last element of string must contain a slash(/)

dir_client="Desktop/scripts" # does cd Desktop/scripts 
dir_client="${dir_client}"
# no slash before Desktop

username_server="name"
password_server="123"
ip_server="192.168.1.20"

user_name=("name1" "name2" "name3" "name4" "name5" "name6" "name7" "name8")
password=("pass1" "pass2" "pass3" "pass4" "pass5" "pass6" "pass7" "pass8")
ip_=("192.168.1.10" "192.168.1.11" "192.168.1.12" "192.168.1.13" "192.168.1.14" "192.168.1.15" "192.168.1.16" "192.168.1.17")

#**********************************************#

#Fetch current date and time
date_current=`date`
echo $date_current
day_=`echo $date_current | cut -d' ' -f1`
month_=`echo $date_current | cut -d' ' -f2`
date_=`echo $date_current | cut -d' ' -f3`
time_=`echo $date_current | cut -d' ' -f4`
country_=`echo $date_current | cut -d' ' -f5`
year_=`echo $date_current | cut -d' ' -f6`
hr_=`echo $time_ | awk -F: '{print $1}'`
min_=`echo $time_ | awk -F: '{print $2}'`
sec_=`echo $time_ | awk -F: '{print $3}'`


# to make sure date is in two digits 
if [ ${#date_} -eq 1 ]
then
date_="0$date_"
fi


# Forming complete names for all months to make directories
# having same names as newly created names
if [ "$month_" = "Jan" ]
then
  month_full_name='January'
elif [ "$month" = 'Feb' ]; then
  month_full_name='February'
elif [ "$month_" = 'Mar' ]; then
  month_full_name='March'
elif [ "$month_" = 'Apr' ]; then
  month_full_name='April'
elif [ "$month_" = 'May' ]; then
  month_full_name='May'
elif [ "$month_" = 'Jun' ]; then
  month_full_name='June'
elif [ "$month_" = 'Jul' ]; then
  month_full_name='July'
elif [ "$month_" = 'Ayg' ]; then
  month_full_name='August'
elif [ "$month_" = 'Sep' ]; then
  month_full_name='September'
elif [ "$month_" = 'Oct' ]; then
  month_full_name='October'
elif [ "$month_" = 'Nov' ]; then
  month_full_name='November'
elif [ "$month_" = 'Dec' ]; then
  month_full_name='December'
fi


path_year=$root_path$year_
path_year="${path_year}"

# check for year directory
if [ ! -d "$path_year" ]; then
  mkdir -p "${path_year}"
fi

path_month=$path_year/$month_full_name
path_month="${path_month}"
# check for month directory
if [ ! -d "$path_month" ]; then
  mkdir -p "${path_month}"
fi

path_date=$path_month/$date_
path_date="${path_date}"
# check for date directory
if [ ! -d "$path_date" ]; then
  mkdir -p "${path_date}"
fi


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

path_daytime=$path_date/$day_time
path_daytime="${path_daytime}"
# check for day time
if [ ! -d "$path_daytime" ]; then
  mkdir "${path_daytime}" 
fi


path_Videos=$path_daytime/Videos
path_Videos="${path_Videos}"
path_HTML=$path_daytime/HTML
path_HTML="${path_HTML}"
# check for a directory named Videos
if [ ! -d "$path_Videos" ]; then
  mkdir -p "${path_Videos}"
fi
# check for a directory named HTML
if [ ! -d "$path_HTML" ]; then
  mkdir -p "${path_HTML}"
fi


count=0 # count for total number of users
for u_name in $user_name
do 
if [ $count -eq 0 ]
then
# Run expect script

expect script_server.exp $u_name ${password[$count]} ${ip_[$count]} $username_server $password_server $ip_server $dir_client
fi
count=`expr $count \+ 1`
done


