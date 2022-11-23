   Info  | Value
-----| ----- 
**Name** | packet_counters.sh
**Date Created** | 2022-11-17
**Version** | 0.3
**Date Updated**| 2022-11-22

## Description
Collects outputs of packet counters and drop counters and logs it to /etc/localgateway/counter_output.txt.
Continous loop. If available disk space is less than 10% then it will stop.
The commands to be run should be saved in cmds.txt file in the same folder as the script 

## How to run the script in the background

`Step1`: Copy the script into the gateway and save it in home directory
`Step2`: write one command in each line in a file named "cmds.txt" in same folder as the script
Here is an example of cmds.txt
sudo ethtool -S eth0 
sudo ip -s -s link show eth0
sudo ip -s link show tun
sudo ip -s tun- show

`Step3`: Run the script in the background
 
```sh
screen -S pktdrop_script  # Name of the screen
sudo ./packet_counters.sh & # Run script in background with nohup
Press ctrl A + D # Detach the screen 
screen -ls (To verify its running in the background)
```
^^^ This will ensure script runs in the background even when the user logs out

## How to kill the script

```sh
ps aux | grep script_name
kill -9 $pid # To kill the script 
```

## Clean up 

Once tracelogs are collected, delete the script and the output file 

```sh
rm -f /home/ubuntu/packet_counters.sh
sudo rm -f /etc/localgateway/counter_output* (Delete all output files)
sudo rm -f /etc/localgateway/packet_counters*
```

