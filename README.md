# shuffle-traffic
Random traffic generator


Usage:

Server:
screen -d -m iperf3 -s -p 5202 & screen -d -m iperf3 -s

Client:
screen -d -m ./shuffle-traffic.sh 127.0.0.1 100 120 12 (replace 127.0.0.1 for server IP)
