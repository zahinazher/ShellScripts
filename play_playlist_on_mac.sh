#!/bin/bash

# This bash script demands path to playlist file as the sole command line argument
# The playlist file should contain the path to all videos to be played
# The temporary playlist file is transformed into the actual/real playlist that
# will be used by VLC
# After playing all the videos in the playlist, the vlc will get closed

# The script will make sure that all the video files path are correct
# If any path is incorrect than it is display a message that the path is incorrect and will exit
# It means that the playlist will not be played unless all the video files path are correct
 
# Note: The system shutdown command demands the user to be in root
# Please mention the user password against the variable 'password' 
# under Modifiable Paramenters Section


# Check to make sure that all arguments are present
if [ ! $# -eq 1 ] ; then
  echo 'Usage: $ bash <play_vid_on_mac.sh> <Path_to_playlist.pls>'  
  exit 0
fi 


#**********Modifiable Parameters/Arguments*************

# It is the sleep time after displaying any message
sleep_time=1  
password="pass"

# Messages to Display
welcome_message="Welcome!"
playlist_message="Starting playlist!"
shutdown_message="Done, shutting down!"

#******************************************************

# It is a playlist file(.pls) that contains path to all videos to be played
playlist_file=$1

# It is the actual playlist that will be used by VLC
real_playlist_file='real_playlist.pls'

echo $welcome_message
sleep $sleep_time
echo $playlist_message
sleep $sleep_time

echo "[playlist]" > $real_playlist_file

count=1 # count number of video files

length=`cat $1 | wc -l`
len=`expr $length \- 2`
while read line
do
if [ $count -le $len ]; then

if [ ! -f "${line}" ]; then
  echo "Video path is incorrect: "$line
  exit 0
fi
fi

echo $line | sed 's/^/File'$count'=/g' >> $real_playlist_file
count=`expr $count \+ 1`

done < $playlist_file
echo "vlc://quit" >> $real_playlist_file

     # Command for Linux OS
echo "" > dump.log
vlc --fullscreen "${real_playlist_file}" quit 2>&1 | tee dump.log &

     # Command for Mac OS
#/Applications/VLC.app/Contents/MacOS/VLC -f -R --no-repeat "$real_playlist_file" vlc://quit

a=1
while [ $a -eq 1 ] ; do
word=`grep -i "failed" dump.log`
if [ "$word" == '' ] ;then
a=1
else
a=2
echo "a becomes equal to 2"
pid=`ps -e | grep -i "vlc" | cut -d' ' -f1`
kill -9 $pid
fi
done

echo $shutdown_message
sleep $sleep_time

#expect play_vid_on_mac.exp "${password}"
