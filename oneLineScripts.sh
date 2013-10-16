################################################
-------Copy files from one dir to another-------
path1='/home/zazher/public_html/FIRENAS/qa-test-data/fp_fn_data/weekly_fp_digest/fp_digest_Aug22-2013' ; path2='/home/zazher/public_html/zahin/intelligencefiles/files/' ; b=$(tr '\n' '\n' < upload.txt) ; x=0;for a in $b ; do d=$path1/$a ; cp $d $path2 ; echo $x ; x=`expr $x \+ 1`; done
**********change name of file same as md5*****************
for i in `ls` ; do md5=`md5sum "${i}"` ; m=`echo "${md5}" |  awk '{print $1}' ` ; mv "${i}" $m ; done
**********Add hhtp response header to md5 list********
for m in `cat md5.txt`;do echo "http://10.5.6.1/~tester/zahin/intelligencefiles/files/"$m >> list11.txt ;done
sed 's/^/http:\/\/10.5.6.1\/~tester\/zahin\/intelligencefiles\/files\//'
*********Get appliance detection result*******************
echo "md5sum","malware_id","weight_DB","profile_name","is_mal","signame","sigtype","sigconf_statc-wei","attcktype","heurtype","sig_identity","host" > detected.csv; for a in `cat m.txt`; do /usr/postgresql/bin/psql -n -t -A -F , -U postgres lms_db -c "select m.md5sum,e.malware_analysis_id,e.esp,m.profile_name,m.is_malicious,e.signature_name,e.signature_type,e.signature_conf,e.attack_type,e.heuristic_type,e.signature_iden,e.host from events as e, malware_analyses as m where e.event_type =11 and m.md5sum='$a' and m.state = 4 and e.malware_analysis_id = m.id"; done >> detected.csv

echo "md5sum","malware_id","server_dns_name" > network.csv; for a in `cat md5.txt`; do /usr/postgresql/bin/psql -n -t -A -F , -U postgres -d lms_db -c "select distinct m.md5sum,e.malware_analysis_id,s.server_dns_name from events as e,malware_analyses as m,cnc_services_events as se,cnc_services as s where m.md5sum='$a' and e.type='NetworkAnomaly' and m.id=e.malware_analysis_id and se.event_id = e.id and se.cnc_service_id = s.id"; done >> network.csv

echo "md5sum","tool_output" > static_info.txt; for a in `cat md5.txt`; do /usr/postgresql/bin/psql -n -t -A -F , -U postgres lms_db -c "select m.md5sum,mi.tool_output from events as e, malware_analyses as m,malware_infos as mi where e.event_type =11 and m.md5sum='$a' and m.profile_name='win7-sp1' and m.state = 4 and e.malware_analysis_id = m.id and m.id=mi.malware_analysis_id"; done >> static_info.txt

**********Submit urls of hashes on appliance thru cli*********
for b in win7-sp1 winxp-sp2 winxp-sp3 ; do echo $b; echo "All Malware ID" > $b.txt ; count=0;for a in `cat list.txt`;do cli -t 'en' 'conf t' 'malware analyze sandbox url '$a' timeout 200  guestos '$b' force' >> $b.txt;count=`expr $count \+ 1`; echo $count ; sleep 1 ;done ; done

*************Snortm, Yara and ClamAV Rules****************************
for a in `ls /data/snort/rules/` ; do echo $a ; cat /data/snort/rules/$a | grep -i 'Rogue.FakeDef' ; done
for a in `find /data/yara/rules/ 'fe'` ; do cat $a | grep -i -F10 'FE_HackTool_IEPass' ; done
/usr/bin/clamdscan --fdpass --no-summary /data/malware/done/13918.malware 2> /dev/null | awk -F':' '{print $NF}' | cut -d' ' -f2

***********extract info against id in jabe*****************
file=1.csv ; id=2559650 ; cli -t 'en' 'config t' 'show incident list' | awk  '$1 >'$id' {print $1}' > ids.txt ; b=$(tr '\n' '\n' <ids.txt) ; for a in $b ; do d=`cli -t 'en' 'config t' 'show incident '$a'' | grep 'Page URL:*' ` ; g=` echo $d | sed 's/Page\ URL\ :\ //' | awk -F/ '{print $1}' ` ; k=$a,$g ; echo $k>>$file ; done

***************Extract File type*************************
file 0132ef9d560c3f6fe2209f673cdc8723 | awk '{print $4}' | sed 's/(/''/' | sed 's/)/''/'  //extract filetype

***********Find a particular file type in a folder***************
f=`find ~/public_html/qa-test-data/eventlog/bugs_FN_FP_TP_data/FPs/clamAV_signature/ -type f -name "*"` ; for a in $f ; do  file $a | awk -F' ' ' $2~'PE32' {print $1}' | sed s/.$/''/ ; done
f=`find ~/public_html/qa-test-data/eventlog/bugs_FN_FP_TP_data/FPs/ -type f -name "*"` ; for a in $f ; do file $a | awk -F' ' ' /DLL/ {print $1} ' | sed s/.$/''/; done

********************************************************
find /home/zazher/public_html/FIRENAS/qa-test-data/fp_fn_data/weekly_fp_digest/ -type f -name 856ded594c026387123c9bc986b69330
find . -type f -name e751eeac6b76ff5d56f423e718d2da85

***********Extract urls thru incident id in JABE**********
file=1.csv ; id=2559650 ; cli -t 'en' 'config t' 'show incident list' | awk  '$1 >'$id' {print $1}' > ids.txt ; b=$(tr '\n' '\n' <ids.txt) ; for a in $b ; do d=`cli -t 'en' 'config t' 'show incident '$a'' | grep 'Page URL:*' ` ; g=` echo $d | sed 's/Page\ URL\ :\ //' | awk -F/ '{print $1}' ` ; k=$a,$g ; echo $k>>$file ; done


***********Extract ZIP files*****************************
mkdir files ;cd files ; for a in `ls ../` ;do if [ 'files' != "$a" ];then echo $a ; unzip -d $a ../$a ; fi  ;done ; mkdir MIDlet ; for b in `ls` ;do if [ 'MIDlet' != "$b" ];then e=`find ./$b -name MANIFEST.MF` ; var=`cat $b/META-INF/MANIFEST.MF | grep -i MIDlet`; if [ "$var" == '' ] ; then echo "NP";else mv $b MIDlet/;fi;fi;done

***********Create a folder same as CVE name and copy its corresponding file*****
awk -F, ' {print $1,$4}' 02-report.csv> op1.txt ; grep -i -o '.*CVE.*[0-9][0-9][0-9][0-9].*[0-9][0-9][0-9][0-9]' op1.txt | sed 's/-\|_//' | sed 's/-\|_//'  > op2.txt ; c=0; for m in `cat op2.txt`; do if [ $(( $c % 2 )) -eq 0 ];then md5=$m ;else cve=$m ;if [ ! -d "$cve" ] ;then mkdir $cve ;fi ; if [ -f "files/$md5.jar" ];then mv files/$md5.jar $cve;fi;fi; c=`expr $c \+ 1` ;done

awk -F, ' {print $1,$4}' 02-report.csv> op1.txt ; grep -i -o '.* CVE.*[0-9][0-9][0-9][0-9].*[0-9][0-9][0-9][0-9]' op1.txt | sed 's/-\|_//'g | sed 's/ /,/'  > op2.txt ; c=0; for m in `cat op2.txt`; do md5=`echo $m | grep -o .*, | sed 's/,//'`;cve=`echo $m | grep -o CVE.*` ; if [ ! -d "$cve" ] ;then mkdir $cve ;fi ; if [ -f "files/$md5.jar" ];then cp files/$md5.jar $cve;fi;done

**********Seperate a string of 1byte each with a comma*********
s=`cat z.txt`; len=${#s}; hlen=`expr $len \- 2` ;c=0;str=''; while [ $c -le $hlen ];do  b=${s:$c:2}; c=`expr $c \+ 1`;str=$str,$b ;done;  echo $str | sed s/^,/''/

**********Extract zipped files in order to upload on VT*******
path='/home/zazher/zippedfiles';a=`ls`;for b in $a ; do type=`file $b`;t=`echo $type | grep -o 'Zip\|RAR'`; if [ 'Zip' == "$t" ];then unzip -n -P infected -d $path $b ;fi;if [ 'RAR' == "$t" ];then echo "rar" ;fi ;done

**********Search Get and Post http request in a pcap**********
count=0 ;fnames=`find . -name '*.pcap' | sed 's/^.\///'`;for name in $fnames ; do val=`tshark -r $name -T fields -E separator=";"  -R "http.request.uri" -e http.request.method -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport -e frame.time` ;v=`echo $val |grep -i 'GET\|POST\|PUT'` ; if [ "$v" != '' ] ; then count=`expr $count \+ 1`; echo $count; fi; done

*********Find a file in a directory that has max size*********
max=0 ; for a in `ls` ;do var=`du $a | awk -F' ' '{print $1}'` ;f=`du $a | awk -F' ' '{print $2}'`;  s=$((var)) ; if [ $((s)) -ge $((max)) ] ;then max=$((s));file_name=$f ; fi; done; echo $file_name 

*******************Practice**********************

for a in `ls` ; do echo $a ; if [ $a == '2.txt' ] ; then echo "bingo"  ; fi ; for b in * ; do if [ $b == '1.txt' ]; then echo "file 1.txt exists" ; fi  ;  done ; done | awk ' $2=="1.txt" {print $1"?what"}'


Tools ssdeep and malwise
