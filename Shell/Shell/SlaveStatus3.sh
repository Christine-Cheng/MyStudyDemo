#!/bin/bash
#define mysql variable
mysql_user="root"
mysql_pass="123456"
email_addr="slave@jb51.net"

mysql_status=$(netstat -nl | awk 'NR>2{if ($4 ~ /.*:3306/) {print "Yes";exit 0}}')
if [ "$mysql_status" == "Yes" ]; then
	slave_status=$(mysql -u${mysql_user} -p${mysql_pass} -e"show slave status\G" | grep "Running" | awk '{if ($2 != "Yes") {print "No";exit 1}}')
	if [ "$slave_status" == "No" ]; then
		echo "slave is not working!"
		[ ! -f "/tmp/slave" ] && echo "Slave is not working!" | mail -s "Warn!MySQL Slave is not working" ${email_addr}
		touch /tmp/slave
	else
		echo "slave is working."
		[ -f "/tmp/slave" ] && rm -f /tmp/slave
	fi
	[ -f "/tmp/mysql_down" ] && rm -f /tmp/mysql_down
else
	[ ! -f "/tmp/mysql_down" ] && echo "Mysql Server is down!" | mail -s "Warn!MySQL server is down!" ${email_addr}
	touch /tmp/mysql_down
fi
