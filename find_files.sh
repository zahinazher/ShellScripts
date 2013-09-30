#!/bin/bash

# This script can be run from any directory
# It creates a file named all_files_list.txt in the current directory that 
# contains the list of files in the system with extension .STpkg
# This script also works even if there are spaces in the file names or
# in the destination directory

# It will find all files with extension '.STpkg' and move them to a directory
# that is specified as your first argument(parameter)

# Check to make sure that all arguments are present
if [ ! $# -eq 1 ] ; then
  echo 'Usage: $ sh <find_files_list.sh> <destination_folder_path>'  
  exit 0
fi 

#****************Modifiable paramters***************#
f_name='all_files_list.txt' 
dest_path=$1 # taken as input from the command terminal
#**********************************************#.

# check for year directory
if [ -d "${dest_path}" ]; then

echo "Searching for files..."

# It will look for all files starting from your root directory
find / -iname '*.STpkg' > $f_name

echo "All files have been found"
echo "Now moving them to the destination directory"
echo "..."

space=' '
while read line
do
mv "${line}" "${dest_path}"
done < $f_name

echo "All searched files have been moved to $dest_path"
echo "Search is Complete"

else
echo "Destination folder does not exist"
fi
