################################################
-------Copy files from one dir to another-------
file=$1 ; path1=$2 ; path2=$2 ; b=$(tr '\n' '\n' < $file) ; for a in $b ; do d=$path1/$a ; cp $d $path2 ; done
path1='/home/user/; path2='/home/user/new_directory; b=$(tr '\n' '\n' < sample.txt) ; for a in $b ; do d=$path1/$a ; cp $d $path2 ; done

------change name of file same as md5-------------------
for i in `ls` ; do md5=`md5sum $i` ; m=`echo $md5 |  awk '{print $1}' ` ; mv $i $m ; done

-------Extract urls thru incident id------------ -----
file=1.csv ; id=2559650 ; cli -t 'en' 'config t' 'show incident list' | awk  '$1 >'$id' {print $1}' > ids.txt ; b=$(tr '\n' '\n' <ids.txt) ; for a in $b ; do d=`cli -t 'en' 'config t' 'show incident '$a'' | grep 'Page URL:*' ` ; g=` echo $d | sed 's/Page\ URL\ :\ //' | awk -F/ '{print $1}' ` ; k=$a,$g ; echo $k>>$file ; done

-------Get appliance detection result-------------------
echo "md5sum","weight","id","signame","sigtype","sigconf","attcktype","heurtype" >> detected.csv; for a in `cat md5.txt`; do /usr/postgresql/bin/psql -n -t -A -F , -U postgres lms_db -c "select m.md5sum,e.esp,e.malware_analysis_id,e.signature_name,e.signature_type,e.signature_conf,e.attack_type,e.heuristic_type from events as e, malware_analyses as m where e.event_type =11 and m.md5sum='$a' and m.state = 4 and e.malware_analysis_id = m.id"; done >> detected.csv

------Submit urls of hashes on appliance thru cli-------
for a in `cat urls.txt`;do cli -t 'en' 'conf t' 'malware analyze sandbox url '$a' timeout 200  guestos winxp-sp3 force';sleep 1;done > t_urls.txt kh.azherrashid@hotmail.com
for b in win7-sp1 winxp-sp2 winxp-sp3 ; do echo $b; echo "All Malware ID" > $b.txt ; count=0;for a in `cat listJune15.txt`;do cli -t 'en' 'conf t' 'malware analyze sandbox url '$a' timeout 200  guestos '$b' force' >> $b.txt;count=`expr $count \+ 1`; echo $count ;done ; done

---------------------------
for a in `ls /data/snort/rules/` ; do echo $a ; cat /data/snort/rules/$a | grep  Trojan.InstallIQ ; done

---------Extract info against incident id ---------------------
file=1.csv ; id=2559650 ; cli -t 'en' 'config t' 'show incident list' | awk  '$1 >'$id' {print $1}' > ids.txt ; b=$(tr '\n' '\n' <ids.txt) ; for a in $b ; do d=`cli -t 'en' 'config t' 'show incident '$a'' | grep 'Page URL:*' ` ; g=` echo $d | sed 's/Page\ URL\ :\ //' | awk -F/ '{print $1}' ` ; k=$a,$g ; echo $k>>$file ; done

-----------------Practice-------------------------------

for a in `ls` ; do echo $a ; if [ $a == '2.txt' ] ; then echo "bingo"  ; fi ; for b in * ; do if [ $b == '1.txt' ]; then echo "file 1.txt exists" ; fi  ;  done ; done | awk ' $2=="1.txt" {print $1"?what"}'
