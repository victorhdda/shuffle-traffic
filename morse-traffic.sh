#/bin/bash

#Morse traffic generator

#Usage message:
[ $# -eq 0 ] && { echo -e "Usage: $0 [IP address] [time(seconds)] '[morse_code]' \n IP address of IPERF3 server \n Time is the trasnmission's duration of every code \n morse_code should be put between '' \nSOS Ex: $0 127.0.0.1 5 '...---...'"; exit 1; }
#Receive code in

# .. ..-. -- --. = ifmg
# 11011210220221

#1 = só upload máximo
#2 = upload e download máximo
#0 = upload e download mínimo



# Receber parâmeto em código morse, -ok

# tratar esses parâmetros: contar, criar condições for para cada um e distinguir quando será TR/RX ou não. - OK

#Tentar uma abordagem por tempo e não por banda - OK

server=$1
timex=$2
morse=$3

echo The following message $morse will be sent to iperf3 server at IP: $server in intervals of $timex [s].

#echo $timex
#echo $morse

timex2=$((timex * 2)) # devem ser usados 2 parênteses
#echo $timex2 dash time durantion

sleep 1
max=200m #max bandwidth
min=15m #min bandwidth, not used.

#space=$((timex / 10)) # not used anymore

for (( i=0; i<${#morse}; i++ )); do
  #echo "${morse:$i:1}" #for debug

  sleep 1

  var=${morse:$i:1}
  #echo $var

  #$var -eq 1

  if [[ "$var" == "."  ]]; then
    # echo var . #not used anymore
    #Quando 1 apenas upload no máximo, download no minimo #not used anymore
    #iperf3 -c $server -Z -t $time -b $max -p 5202 >/dev/null #not used anymore

    iperf3 -c $server -Z -t $timex -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $timex -b $max -p 5202 >/dev/null #download

    wait

  elif [[ "$var" == "-" ]]; then
    #echo var - #not used anymore
    #Quando 2 download e upload no maximo

    iperf3 -c $server -Z -t $timex2 -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $timex2 -b $max -p 5202 >/dev/null #download

    wait

  elif [[ "$var" == " " ]]; then
    #echo var space #not used anymore
    #quando 0 download e upoad no mínimo
    #quando 0 sleep timex

    sleep $timex # sleep interval for space caracter

    #iperf3 -c $server -Z -t $space -b $min >/dev/null & #UPLOAD
    #iperf3 -c $server -R -Z -t $space -b $min -p 5202 >/dev/null #download

    wait
  fi
  #echo sleeping step #not used anymore
  #echo $timex #not used anymore
  #time sleep $timex #not used anymore
  sleep $timex # sleep interval between caracters
  #echo wake up after "$timex" seconds #not used anymore
done

exit






#foo=string
#for (( i=0; i<${#foo}; i++ )); do
#  echo "${foo:$i:1}"
#done
