#!/bin/bash

if [ $# -eq 0  ]
then
	echo "Usage: forker.sh <forks_number> <spam_file>"
	exit 1;
fi

for i in `seq 1 $1`
do
	$pid=`nc localhost 25 < $2`
done
echo "Done... Phew!"