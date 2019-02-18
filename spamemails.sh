#!/bin/bash
pprocess=`ps -ef | grep "spamemails.sh" | grep -v "grep" | wc -l`;
if [ "$pprocess"  -le 2 ]
then
{
sh /usr/local/src/newmalicious.sh >> /usr/local/src/permupdates.txt;
}
fi


Sub script File: /usr/local/src/newmalicious.sh

#/bin/bash
echo > /usr/local/src/newmalicious.txt
for i in `tail -5000 /var/log/exim_mainlog | grep cwd | grep -v "/var/spool/exim" | replace "cwd=" "%" | cut -d "%" -f2 | awk '{print $1}' | grep -w "public_html" | uniq | sort -u`; do
grep -lr '"64_decode";return' $i >> /usr/local/src/newmalicious.txt;
done
for j in `cat /usr/local/src/newmalicious.txt | grep -v -e '^$'`; do
set -x
chown root.root  $j;
chmod 000 $j;
spamuser=`echo $j | cut -d '/' -f3`;
pkill -u $spamuser;
set +x
exim -bpru | grep $spamuser | awk {'print $3'}| xargs exim -Mrm
exim -bpr | grep frozen | awk {'print $3'} | xargs exim -Mrm;
exim -bpru | grep '<>' | awk {'print $3'}| xargs exim -Mrm;
done


