#!/bin/bash
#Author: github.com/victorhdda licenceses and refereces are linked at the author repository.
#This script generate a traffic between server and client. The max and min bandwidth traffic are a result of  transcoded morse code input. The result can be visualized through network graphics tools like (zabbix, mrtg, or linux speedometer).

#Usage message:
[ $# -eq 0 ] && { echo -e "Usage: $0 [IP address] [time] '[morse_code]' \n [IP address]: IPERF3 server's IP address.  \n [time]: character time duration in seconds. \n [morse_code]: should be put between ''. Accepted caracters dot(.) dash (-) slash (/) space ( )  \n S O S's Example: $0 127.0.0.1 5 '... / --- / ...' \n To view the result, run another terminal with: speedometer -r lo -t lo -s"; exit 1; }

#Set vars
server=$1
timex=$2
morse=$3
timex2=$((timex * 2))
max=200m #max bandwidth

#Total execution time calculation
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

for (( i=0; i<${#morse}; i++ )); do #Main loop: execution of each character
  #echo "${morse:$i:1}" #for debug
  sleep 1 # stopable point
  var=${morse:$i:1}

  if [[ "$var" == "."  ]]; then # if . execute iperf3 with max upload and download bandwidth
    iperf3 -c $server -Z -t $timex -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $timex -b $max -p 5202 >/dev/null #download
    wait

  elif [[ "$var" == "-" ]]; then # if - execute iperf3 with max upload and download bandwidth
    iperf3 -c $server -Z -t $timex2 -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $timex2 -b $max -p 5202 >/dev/null #download
    wait

  elif [[ "$var" == " "  ]]; then # if space stop traffic for a specific time
    sleep $timex # sleep interval for space caracter
    wait

  elif [[ "$var" == "/"  ]]; then # if / stop traffic for a specific time
    sleep $timex # sleep interval for slash caracter
    wait
  fi

sleep $timex # default sleep interval between caracters
done

exit
