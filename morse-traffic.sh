#!/bin/bash
#Move to validation and then pull request to master
#Morse traffic generator
#Usage message:
[ $# -eq 0 ] && { echo -e "Usage: $0 [IP address] [time(seconds)] '[morse_code]' \n IPERF3 server's IP address.  \n Time: character time duration. \n morse_code should be put between ''. Accepted caracters dot(.) dash (-) slash (/) space ( )  \n S O S Ex: $0 127.0.0.1 5 '... / --- / ...'"; exit 1; }

#Set vars
server=$1
timex=$2
morse=$3
timex2=$((timex * 2))
max=200m #max bandwidth

#Time calculation
cont_dash=0 #dash counter
cont_other=0
for (( i=0; i<${#morse}; i++ )); do
  var=${morse:$i:1}
  if [[ "$var" == "-" ]]; then
    let "cont_dash++"
  fi
done

duration=$(($timex*2*${#morse}+$cont_dash*$timex+${#morse}+1)) #time_of_each_char * 2 (space_time) * number_of_chars + number_of_dash*time_of_each_char + sleep_of_each_for
duration=$(date -d@$duration -u +%dd%Hh%Mm%Ss)

echo -e "The following message $morse will be sent to iperf3 server at IP: $server. \nCharacter duration set to $timex [s]. \nThis will long ~ $duration."


for (( i=0; i<${#morse}; i++ )); do
  #echo "${morse:$i:1}" #for debug
  sleep 1 # stopable point
  var=${morse:$i:1}

  if [[ "$var" == "."  ]]; then

    iperf3 -c $server -Z -t $timex -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $timex -b $max -p 5202 >/dev/null #download
    wait

  elif [[ "$var" == "-" ]]; then
    iperf3 -c $server -Z -t $timex2 -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $timex2 -b $max -p 5202 >/dev/null #download
    wait

  elif [[ "$var" == " "  ]]; then
    sleep $timex # sleep interval for space caracter
    wait

  elif [[ "$var" == "/"  ]]; then
    #echo "/"
    sleep $timex # sleep interval for slash caracter
    wait
  fi
sleep $timex # sleep interval between caracters
done
exit
