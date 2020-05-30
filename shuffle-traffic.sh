#!/bin/bash
#Author: github.com/victorhdda licenses and refereces are linked at the author repository.
#This script generate a traffic between server and client. The max and min bandwidth traffic are shuffled.
# Pre-requisites: the connection server should run 2 instances of iperf3, one on default port (5201) and another on port (5202); the localhost should have iperf3 installed

# sintaxe: ./suffle-traffic host iterations step_seconds step_band
# Example: ./shuffle-traffic 127.0.0.1 1 2 10

#Usage message:
[ $# -eq 0 ] && { echo -e "Usage: $0 [IP address] [number_of_executions] [step_time] [step_bandwidth] \n [IP address]: IPERF3 server's IP address.  \n [number_of_executions]: number of desired executions. \n [step_time]: (seconds) step of aleatory time duration, will be aleatory multiplyed by (1..10). \n [step_bandwidth]: (mbps) step of aleatory bandwidth between server and client, will be aleatory multiplyed by (1..10).\n Example: $0 127.0.0.1 5 1 10"; exit 1; }

#Set vars
server=$1
iterations=$2
step_seconds=$3
step_band=$4

echo Starting script...

duration=$(($step_seconds*10*$iterations+2)) # Calculates the max execution time: (step_seconds)*(max value of aleatory multiplication)*(number of iterations)*(sleep in each for iteration)+err_margin
duration=$(date -d@$duration -u +%dd%Hh%Mm%Ss) # Display var in date format
echo The maximum time duration of this execution will be: $duration

for i in $(eval echo "{1..$iterations}")
do
	echo Start of execution: $i
		#generate aleatory time execution
	time=`shuf -i 1-10 -n 1`
	time="$(($time*$step_seconds))"
	echo The shuffle time is: $time seconds
		#generate aleatory downlaod bandwidth
	download=`shuf -i 1-10 -n 1`
	download="$(($download*$step_band))"m
	echo The shuffle download bandwidth is: "$download"bps
		#generate aleatory upload bandwidth
	upload=`shuf -i 1-10 -n 1`
	upload="$(($upload*$step_band))"m
	echo The shuffle upload bandwidth is: "$upload"bps
		#executes iperf3 on 2 ways. Default port 5201 is used for upload and port 5202 is used for download.
	sleep 1 #stopable point
	iperf3 -c $server -Z -t $time -b $upload > /dev/null & # run in parallel with above command
	iperf3 -c $server -R -Z -t $time -b $download -p 5202 > /dev/null # send all outputs to null

	wait
	echo End of execution $i
done
echo "DONE"
exit


#---------MELHORIAS


#Exportar dados .csv
#Utilizar parâmetros de execução baseados em letras: -b -r ao invés de variáveis.
# https://github.com/tmgstevens/iperf-scripting/blob/master/iperf.sh / https://github.com/tmgstevens/iperf-scripting

#Receber endereços IP de vários servidores
#Escanear a rede em busca de servidores ativos
#Modo full auto, detecta velocidade máxima de banda e trabalha com ela
#Inserir comando de parada, interrupçaõ de execuções

#Tornar a conexão persistente para o cliente e servidor, em casos de quedas do link

#Enviar para um arquivo as estatísticas de execução, talvez apenas a útilma linha de execução do iperf: https://github.com/tmgstevens/iperf-scripting/blob/master/iperf-multiway.sh
#Opção para atuar em modo duplex opcional - OK
#Inserir tempo de parada?

#Criar GUI
#Empacotar em um APP, package ? - Escrever em python, C++?

# Comentar código


#Seção de help:
#https://github.com/rveznaver/NagiosBandwidthCheck/blob/master/check_iperf

#------------------

#host=127.0.0.1


#time=60
#payload=10G
#band=1m
#step_seconds=300
#step_band=10


#time=`shuf -i 1-4 -n 1`
#time="$(($time*300))"
#echo $time


#Variable loop
#START=1
#END=5
#for i in $(eval echo "{$START..$END}")
#do
#	echo "$i"
#done

#echo $iterations
#for i in $(eval echo "{1..$iterations}")
#do
#	echo "$i"
#done
