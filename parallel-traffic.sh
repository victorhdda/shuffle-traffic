#!/bin/bash

server=$1
iterations=$2
step_seconds=$3
step_band=$4
direction=$5

#echo $1 $2 $3 $4 $5

#./parallel-traffic.sh 127.0.0.1 10 1 10 0


for i in $(eval echo "{1..$iterations}")
do
	echo Start of execution: $i
	time=`shuf -i 1-10 -n 1`
	time="$(($time*$step_seconds))"
	echo The shuffle time is: $time seconds

	bandwidth=`shuf -i 1-10 -n 1`
	bandwidth="$(($bandwidth*$step_band))"m
	echo The shuffle bandwidth is: "$bandwidth"bps


  if [[ $direction -eq 1 ]]; then
    echo reverso
    iperf3 -c $server -R -Z -t $time -b $bandwidth -p 5202 >/dev/null

  else
    iperf3 -c $server -Z -t $time -b $bandwidth > /dev/null
  fi



  wait
done

exit

# Colocar case para outros tipos de de execuções
# morse code image to graphs
