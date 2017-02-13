#!/bin/bash
# Detects disallowed logins. And bans them :)
# This is old, but it still works.
THRESHOLD=3
TMPFILE=$(mktemp)
TMPFILE2=$(mktemp)
if [ `date '+%M'` -ge 5 ] 
	then
	DATE=`date '+%h %e %H:'` 
	else
	DATE=`date '+%h %e %H:' '-d 1 hour ago'`
fi
#
# Grep bad login attempts from /var/log/secure
# This line gets rid of built in users (ie root, bin, daemon)
grep "not allowed because not listed" /var/log/secure|grep "$DATE" |awk {'print $9'} |sort >> $TMPFILE
# This gets rid of wrongly guessed usernames 
grep "Invalid user " /var/log/secure|grep "$DATE" |awk {'print $10'} |sort >> $TMPFILE
#
#
if [ -s $TMPFILE ] 
	then
	cat $TMPFILE | sort |uniq -c |sed -e 's/^[ \t]*//'|tr ' ' '|'  >> $TMPFILE2
	rm $TMPFILE
	for i in `cat $TMPFILE2`
		do 
			if [ `echo $i | awk -F '|' '{print $1}'` -ge $THRESHOLD ]
			then
			echo `echo $i | awk -F '|' '{print $2}'` >> $TMPFILE
			fi
		done
	for i in `cat $TMPFILE`
		do
			grep $i /etc/hosts.deny > /dev/null 2>&1 
			if [ $? -eq 1 ]
				then
				echo "Banning $i"
				echo "sshd: $i" >> /etc/hosts.deny
				echo "$i has been added to banlist" >> /var/log/secure
				else 
				echo "$i is already in hosts.deny, skipping..."
			fi
		done
	else
	echo "No baddies found."
fi
if [ -e $TMPFILE ] 
	then
	rm $TMPFILE
fi

if [ -e $TMPFILE2 ] 
	then
	rm $TMPFILE2
fi

