#/bin/bash

#Morse traffic generator

#Receive code in

# .. ..-. -- --. = ifmg
# 11011210220221

#1 = só upload máximo
#2 = upload e download máximo
#0 = upload e download mínimo



# Receber parâmeto em código morse, tratar esses parâmetros: contar, criar condições for para cada um e distinguir quando será TR/RX ou não.

server=$1

time=$2
morse=$3

echo $server
echo $time
echo $morse

sleep 1
max=40m
min=15m

for (( i=0; i<${#morse}; i++ )); do
  echo "${morse:$i:1}"

  sleep 1

  var=${morse:$i:1}
  #echo $var

  #$var -eq 1

  if [[ $var -eq 1  ]]; then
    echo var 1
    #Quando 1 apenas upload no máximo, download no minimo
    #iperf3 -c $server -Z -t $time -b $max -p 5202 >/dev/null

    iperf3 -c $server -Z -t $time -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $time -b $min -p 5202 >/dev/null #download

  elif [[ $var -eq 2 ]]; then
    echo var 2
    #Quando 2 download e upload no maximo

    iperf3 -c $server -Z -t $time -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $time -b $max -p 5202 >/dev/null #download

  elif [[ $var -eq 0 ]]; then
    echo var 0
    #quando 0 download e upoad no mínimo

    iperf3 -c $server -Z -t $time -b $min >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $time -b $min -p 5202 >/dev/null #download
  fi

done











#foo=string
#for (( i=0; i<${#foo}; i++ )); do
#  echo "${foo:$i:1}"
#done
