#!/bin/bash

set -e
source spike-script.conf
source vars
echo $USERNAME
echo $PASSWORD
echo $IPADDRESS

check_response()
{
	val=$(echo $val | awk -F"," -v OFS="," ' { for(i=0;NF- i++;){sub("[.]*0+ *$","",$i)};$1=$1 }1 ')
	if echo "$response" | grep $val
	then
		echo "Match Found"
	else
		exit 1
	fi
}

response=$(curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=spike_test" --data-urlencode "q=SELECT value FROM cpu_load_short")
val=$CPU
check_response

response=$(curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=spike_test" --data-urlencode "q=SELECT value FROM mem_load_short")
val=$MEMORY
check_response 

response=$(curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=spike_test" --data-urlencode "q=SELECT value FROM disk_read_short")
val=$DISKREADSEC
check_response 

response=$(curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=spike_test" --data-urlencode "q=SELECT value FROM disk_write_short")
val=$DISKWRITESEC
check_response 


# #delete spike_test database 
response=$(curl -i -XPOST http://localhost:8086/query --data-urlencode "q=DROP DATABASE spike_test")
if ! (echo "$response" | grep '2[0-9][0-9]')
then
	exit 1
fi

exit

set e+
