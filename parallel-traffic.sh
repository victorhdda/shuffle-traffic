#!/bin/bash
#Author: github.com/victorhdda licenceses and refereces are linked at the author repository.
#This script evaluate de traffic between server and client in a shuffled way. It can be associated wit linux parallel to mix rx and tx traffic at same time and have a better evaluation of capabilities of your connection. Most of bandwidth tests evaluate Rx and Tx in a separeted tests, not evaluating the real capabilities of the network to deal with duplex connections.

#Usage message:
[ $# -eq 0 ] && { echo -e "Usage: $0 [IP address] [number_of_executions] [step_time] [step_bandwidth] [reverso_enable]\n [IP address]: IPERF3 server's IP address. \n [number_of_executions]: Number of executions \n [step_time]: (seconds) step of aleatory time duration, will be aleatory multiplyed by (1..10). \n [step_bandwidth]: (mbps) step of aleatory bandwidth between server and client, will be aleatory multiplyed by (1..10).\n [reverso_enable]: should be 1 (enabled), 0 (disabled) or empty (disabled). Reverse execution requires iperf3 server on port 5202 \n Ex.: $0 127.0.0.1 5 10 120 \n Ex. reverso enabled: $0 127.0.0.1 5 10 120 1 \n Ex. running with linux parallel: parallel ::: 'bash $0 127.0.0.1 5 10 120 ' 'bash $0 127.0.0.1 5 10 120 1'" ; exit 1; }

#Set vars
server=$1
iterations=$2
step_seconds=$3
step_band=$4
direction=$5

#echo $1 $2 $3 $4 $5 # for debug

for i in $(eval echo "{1..$iterations}")
do
	sleep 1 # stopable point
	echo Start of execution: $i
	time=`shuf -i 1-10 -n 1` # creating a aleatory time
	time="$(($time*$step_seconds))"
	echo The shuffle time is: $time seconds

	bandwidth=`shuf -i 1-10 -n 1` # creating a aleatory bandwidth
	bandwidth="$(($bandwidth*$step_band))"m
	echo The shuffle bandwidth is: "$bandwidth"bps

  if [[ $direction -eq 1 ]]; then #evaluation of direction (reverse or not)
    echo Reverse execution enabled #For debug or later identification
    iperf3 -c $server -R -Z -t $time -b $bandwidth -p 5202 >/dev/null
  else
		echo Reverse execution disabled
    iperf3 -c $server -Z -t $time -b $bandwidth > /dev/null
  fi
  wait
done
exit
