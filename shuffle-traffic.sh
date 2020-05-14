#!/bin/bash
# sintaxe: ./suffle-traffic host iterations step_seconds step_band
# Example: ./shuffle-traffic 127.0.0.1 1 2 10
# Requisites: the connection server should run 2 instances of iperf3, one on default port (5201) and another on port (5202); the localhost should have iperf3 installed

server=$1
iterations=$2
step_seconds=$3
step_band=$4

echo Starting script...

sleep 2

for i in $(eval echo "{1..$iterations}")
do
	echo Start of execution: $i
	time=`shuf -i 1-10 -n 1`
	time="$(($time*$step_seconds))"
	echo The shuffle time is: $time seconds

	download=`shuf -i 1-10 -n 1`
	download="$(($download*$step_band))"m
	echo The shuffle download bandwidth is: "$download"bps

	upload=`shuf -i 1-10 -n 1`
	upload="$(($upload*$step_band))"m
	echo The shuffle upload bandwidth is: "$upload"bps

	sleep 2

	iperf3 -c $server -Z -t $time -b $upload > /dev/null &

	iperf3 -c $server -R -Z -t $time -b $download -p 5202 > /dev/null

	wait
	echo End of execution $i
	done

	wait
	echo "End of script."


exit


#---------MELHORIAS

# Avaliar o link por um determinado ciclo, com execuções aleatórias e tempo(5,10,15 e 20 minutos) e banda (10, 20, 30, 40, 50, 60)
#Receber parametros via comando de terminal
#Referencial de download e upload em relação a máquina que executa o script
#Calculo de tempo de execução máximo step_seconds*10*iterations


#Receber parâmetros do servidor via terminal: IP, número de interações, step_seconds, step band - OK

#Receber endereços IP de vários servidores
#Escanear a rede em busca de servidores ativos
#Modo full auto, detecta velocidade máxima de banda e trabalha com ela
#Inserir comando de parada, interrupçaõ de execuções
#Informar tempo estimado de execução em horas e dias
#Tornar a conexão persistente para o cliente e servidor, em casos de quedas do link

#Enviar para um arquivo as estatísticas de execução, talvez apenas a útilma linha de execução do iperf
#Opção para atuar em modo duplex opcional
#Inserir tempo de parada?

#Agendar execução via cron
#Opção para realizar uploads e downloads em tempos diferentes
#Criar GUI
#Empacotar em um APP ? - Escrever em python, C++?

#postar no git
#colocar em inglês

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
