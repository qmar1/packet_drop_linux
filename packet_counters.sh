#!/bin/bash

# Script Information
ver=0.3
date_created=2022-11-17
date_modified=2022-11-23
name=packet_counters.sh

i=1 # Just a counter for iterating
MaxFileSize=10485760 # 10MB
OutputFile="/etc/localgateway/counter_output.txt" #where stats output will be saved
LogFile="/etc/localgateway/packet_counters.log" #where script related logs will be saved
SleepTimer=10 # Time in seconds
MaxDiskUsage=90 # Percentage
declare -a cmds # array for commands to be run

print_basic_script_info()
    {
    seperator=--------------------
    seperator=$seperator$seperator
    rows="%-25s|%s \n"
    TableWidth=50

    printf "$rows" Info Value
    printf "%.${TableWidth}s\n" "$seperator"
    printf "$rows" "Name" "$name"
    printf "$rows" "Ver" "$ver"
    printf "$rows" "Date_Created" "$date_created"
    printf "$rows" "Date_Modified" "$date_modified"
}
print_add_script_info()
{
read -r -d '' help_msg2 << 'helpout'
**** HELP ****
--------------

DESCRIPTION:
------------
Collects outputs of packet counters and drop counters and logs it to /etc/localgateway/counter_output.txt.
Continous loop. If available disk space is less than 10% then it will stop.
Commands to be run should be saved in the cmds.txt file.

HOW TO RUN THE SCRIPT IN BACKGROUND:
----------------------------------------
STEP-1: Copy the script into the gateway and save it in home directory
STEP-2: write one command in each line in file name "cmds.txt" in the same folder as the script
Here is an example of cmds.txt
sudo ethtool -S eth0
sudo ip -s -s link show eth0
sudo ip -s link show tun
sudo ip -s tun- show

STEP-3: Run the script in the background
screen -S pktdrop_script  # Name of the screen
sudo ./packet_counters.sh & # Run script in background
Press ctrl A + D # Detach the screen
screen -ls (To verify its running in the background)
^^^ This will ensure script runs in the background even when the user logs out
**Alternate option to run code in background**
nohup sudo ./packet_counters.sh &

HOW TO KILL THE SCRIPT:
----------------------
ps aux | grep script_name
kill -9 $pid # To kill the script

CLEAN UP:
---------
Once tracelogs are collected, delete the script and the output file

rm -f /home/ubuntu/packet_counters.sh
sudo rm -f /etc/localgateway/counter_output* (Delete all output files)
sudo rm -f /etc/localgateway/packet_counters.log (Delete log file)
helpout
echo "$help_msg2"
}

help_option()
{
    print_basic_script_info
    echo " "
    print_add_script_info
}

# Get commands from the cmds.txt file and store them in an array
# If the system does not have mpstat installed or sar installed, then those commands will not be stored and run
# If SAR or MPSTAT is not installed it will log that info to logfile location and skip running those commands
get_cmds_frm_file()
{
    arr_indx=0
    while read line
    do
    # Skip empty lines
        [ -z "$line" ] && continue
    # Skip mpstat and sar commands if they are NOT installed on the system
        [ $(echo "$line" | awk '{print $2}') == "mpstat" ] &&  [ $mpstat_avail == "false" ] && continue
        [ $(echo "$line" | awk '{print $2}') == "sar" ] &&  [ $sar_avail == "false" ] && continue
        cmds[$arr_indx]="$line"
        ((arr_indx++))
    done < cmds.txt
}

# --- Create output file and if it already exists backup the old one
backup_old_files()
{
    if [ -e $OutputFile ];then
        echo "Old File exits"
        timestamp=`date +"%Y-%m-%d-%I-%M-%S"`
        sudo mv $OutputFile $OutputFile.$timestamp.old
        sudo gzip $OutputFile.$timestamp.old
    else
        sudo touch $OutputFile
    fi
}

# --- Check if mpstat is available in the system , if not don't run mpstat commands
check_mpstat_installed()
{
    mpstat -V > /dev/null 2>&1
    if [ $? = 0 ];then
        mpstat_avail="true"
    else
        mpstat_avail="false"
        now=$(date +"%Y-%m-%d:%I:%M:%S :")
        echo "$now Skipping mpstat output as its not installed" >> $LogFile
    fi
}

# --- Check if SAR is available in the system , if not don't run SAR commands
check_sar_installed()
{
    sar -V > /dev/null 2>&1
    if [ $? = 0 ];then
        sar_avail="true"
    else
        sar_avail="false"
        now=$(date +"%Y-%m-%d:%I:%M:%S :")
        echo "$now Skipping sar related output as its not installed" >> $LogFile
    fi
}

# --- Check disk space, if less than 10% free log & abort script
check_disk_util()
{
	DiskUsed=`df -hT | grep /$ | awk '{print $(NF - 1)}' | cut -d '%' -f1`
	if [ $DiskUsed -gt $MaxDiskUsage ]; then
        	echo " " >> $OutputFile 2>/dev/null
        	echo " " >> $OutputFile 2>/dev/null
        	echo "--- End Script ---" >> $OutputFile 2>/dev/null
        	echo "Disk utilization: $DiskUsed is > $MaxDiskUsage, aborting script " >> $OutputFile 2>/dev/null
        	echo "sudo df -hT" >> $OutputFile 2>/dev/null
        	sudo df -hT >> $OutputFile 2>/dev/null
		echo "stop"
	fi
}

# --- Iteration count and Date
output_date_iteration()
    {
    echo " " >> $OutputFile 2>/dev/null
    echo " " >> $OutputFile 2>/dev/null
    echo "========================" >> $OutputFile 2>/dev/null
    echo "Iteration: $i" >> $OutputFile 2>/dev/null
    date +"%Y-%m-%d:%I:%M:%S" >> $OutputFile 2>/dev/null
    echo "========================" >> $OutputFile 2>/dev/null
    }

# --- Check log file size and rotate it
rotate_compress_output_file()
{
    file_size=`sudo du -b $OutputFile | tr -s '\t' ' ' | cut -d ' ' -f1`
    if [ $file_size -gt $MaxFileSize ];then
        timestamp=`date +"%Y-%m-%d-%I-%M-%S"`
        sudo mv $OutputFile $OutputFile.$timestamp
        sudo gzip $OutputFile.$timestamp
        sudo touch $OutputFile
    fi
}

# --- Main code
if [[ $# -gt 1 ]]; then
    echo "Only supported option argument is -h (for help)"
    exit 10
elif [[ $1 == '-h' ]]; then
    help_option
elif [[ $1 == '' ]]; then
    check_mpstat_installed
    check_sar_installed
    get_cmds_frm_file
    backup_old_files
    to_continue=$(check_disk_util)
    while :
    do
        if [ "$to_continue" == "stop" ]; then
        break 2
        fi
        output_date_iteration
        for indx in ${!cmds[*]}; do
            echo " " >> $OutputFile 2>/dev/null
            echo "${cmds[indx]}" >> $OutputFile 2>/dev/null
            echo " " >> $OutputFile 2>/dev/null
            ${cmds[indx]} >> $OutputFile 2>/dev/null
        done
        ((i++))
        rotate_compress_output_file
        sleep $SleepTimer
    done
elif [[ $1 != '-h' ]]; then
    echo "Not a correct argument. Only supported argument is -h (for help)"
    exit 10
fi