#!/bin/bash
# Check to make sure that all arguments are present
if [ ! $# -eq 1 ] ; then
  echo 'Usage: $ sh filename.sh ip'  
  exit 0
fi 

#****************Input paramters***************#
root_path='./'  # need to replace with real path
#**********************************************#.

ip_range=$1

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

directory_year=$year_
# check for year directory
if [ ! -d "$root_path$directory_year/" ]; then
  mkdir $root_path$directory_year
fi
# check for month directory
if [ ! -d "$root_path$directory_year/$month_full_name" ]; then
  mkdir $root_path$directory_year/$month_full_name
fi
# check for date directory
if [ ! -d "$root_path$directory_year/$month_full_name/$date_" ]; then
  mkdir $root_path$directory_year/$month_full_name/$date_
fi

# check day time each day
if [ $((hr_)) -ge 0 -a $((hr_)) -le 12 ]
then
  day_time='Morning'
else
  day_time='Afternoon'
fi
# check for day time
if [ ! -d "$root_path$directory_year/$month_full_name/$date_/$day_time" ]; then
  mkdir $root_path$directory_year/$month_full_name/$date_/$day_time 
fi
# check for a directory named Videos
if [ ! -d "$directory_year/$month_full_name/$date_/$day_time/Videos" ]; then
  mkdir $root_path$directory_year/$month_full_name/$date_/$day_time/Videos
fi
# check for a directory named HTML
if [ ! -d "$root_path$directory_year/$month_full_name/$date_/$day_time/HTML" ]; then
  mkdir $root_path$directory_year/$month_full_name/$date_/$day_time/HTML
fi


