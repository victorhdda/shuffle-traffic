#/bin/bash

#Morse traffic generator

#Receive code in

# .. ..-. -- --. = ifmg
# 11011210220221

#1 = só upload máximo
#2 = upload e download máximo
#0 = upload e download mínimo



# Receber parâmeto em código morse, tratar esses parâmetros: contar, criar condições for para cada um e distinguir quando será TR/RX ou não.

#Tentar uma abordagem por tempo e não por banda

server=$1

timex=$2
morse=$3

echo $server
echo $timex
echo $morse

timex2=$((timex * 2)) # devem ser usados 2 parênteses
echo $timex2

sleep 1
max=200m
min=15m

space=$((timex / 10))

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

    iperf3 -c $server -Z -t $timex -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $timex -b $max -p 5202 >/dev/null #download

    wait

  elif [[ $var -eq 2 ]]; then
    echo var 2
    #Quando 2 download e upload no maximo

    iperf3 -c $server -Z -t $timex2 -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $timex2 -b $max -p 5202 >/dev/null #download

    wait

  elif [[ $var -eq 0 ]]; then
    echo var 0
    #quando 0 download e upoad no mínimo
    #quando 0 sleep timex

    sleep $timex

    #iperf3 -c $server -Z -t $space -b $min >/dev/null & #UPLOAD
    #iperf3 -c $server -R -Z -t $space -b $min -p 5202 >/dev/null #download

    wait
  fi
  echo sleeping step
  echo $timex
  time sleep $timex
  echo wake up after "$timex" seconds
done




exit






#foo=string
#for (( i=0; i<${#foo}; i++ )); do
#  echo "${foo:$i:1}"
#done
