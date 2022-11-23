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

## Sample Log output
```sh
2022-11-23:11:49:47 : Skipping mpstat output as its not installed
2022-11-23:11:49:47 : Skipping sar related output as its not installed
```
## Sample Counters output
```sh
========================
Iteration: 37
2022-11-23:12:07:22
========================

sudo ethtool -S eth0

NIC statistics:
     tx_timeout: 0
     suspend: 0
     resume: 0
     wd_expired: 0
     interface_up: 2
     interface_down: 1
     admin_q_pause: 0
     bw_in_allowance_exceeded: 0
     bw_out_allowance_exceeded: 0
     pps_allowance_exceeded: 0
     conntrack_allowance_exceeded: 0
     linklocal_allowance_exceeded: 0
     queue_0_tx_cnt: 33539
     queue_0_tx_bytes: 3794749
     queue_0_tx_queue_stop: 0
     queue_0_tx_queue_wakeup: 0
     queue_0_tx_dma_mapping_err: 0
     queue_0_tx_linearize: 0
     queue_0_tx_linearize_failed: 0
     queue_0_tx_napi_comp: 58970
     queue_0_tx_tx_poll: 59067
     queue_0_tx_doorbells: 33392
     queue_0_tx_prepare_ctx_err: 0
     queue_0_tx_bad_req_id: 0
     queue_0_tx_llq_buffer_copy: 0
     queue_0_tx_missed_tx: 0
     queue_0_tx_unmask_interrupt: 58970
     queue_0_rx_cnt: 183700
     queue_0_rx_bytes: 262838443
     queue_0_rx_rx_copybreak_pkt: 7456
     queue_0_rx_csum_good: 0
     queue_0_rx_refil_partial: 0
     queue_0_rx_bad_csum: 0
     queue_0_rx_page_alloc_fail: 0
     queue_0_rx_skb_alloc_fail: 0
     queue_0_rx_dma_mapping_err: 0
     queue_0_rx_bad_desc_num: 0
     queue_0_rx_bad_req_id: 0
     queue_0_rx_empty_rx_ring: 0
     queue_0_rx_csum_unchecked: 0
     queue_0_rx_xdp_aborted: 0
     queue_0_rx_xdp_drop: 0
     queue_0_rx_xdp_pass: 0
     queue_0_rx_xdp_tx: 0
     queue_0_rx_xdp_invalid: 0
     queue_0_rx_xdp_redirect: 0
     queue_0_rx_lpc_warm_up: 0
     queue_0_rx_lpc_full: 0
     queue_0_rx_lpc_wrong_numa: 0
     queue_1_tx_cnt: 32452
     queue_1_tx_bytes: 3200766
     queue_1_tx_queue_stop: 0
     queue_1_tx_queue_wakeup: 0
     queue_1_tx_dma_mapping_err: 0
     queue_1_tx_linearize: 0
     queue_1_tx_linearize_failed: 0
     queue_1_tx_napi_comp: 54416
     queue_1_tx_tx_poll: 54430
     queue_1_tx_doorbells: 32195
     queue_1_tx_prepare_ctx_err: 0
     queue_1_tx_bad_req_id: 0
     queue_1_tx_llq_buffer_copy: 0
     queue_1_tx_missed_tx: 0
     queue_1_tx_unmask_interrupt: 54416
     queue_1_rx_cnt: 34538
     queue_1_rx_bytes: 24196718
     queue_1_rx_rx_copybreak_pkt: 18913
     queue_1_rx_csum_good: 0
     queue_1_rx_refil_partial: 0
     queue_1_rx_bad_csum: 0
     queue_1_rx_page_alloc_fail: 0
     queue_1_rx_skb_alloc_fail: 0
     queue_1_rx_dma_mapping_err: 0
     queue_1_rx_bad_desc_num: 0
     queue_1_rx_bad_req_id: 0
     queue_1_rx_empty_rx_ring: 0
     queue_1_rx_csum_unchecked: 0
     queue_1_rx_xdp_aborted: 0
     queue_1_rx_xdp_drop: 0
     queue_1_rx_xdp_pass: 0
     queue_1_rx_xdp_tx: 0
     queue_1_rx_xdp_invalid: 0
     queue_1_rx_xdp_redirect: 0
     queue_1_rx_lpc_warm_up: 0
     queue_1_rx_lpc_full: 0
     queue_1_rx_lpc_wrong_numa: 0
     ena_admin_q_aborted_cmd: 0
     ena_admin_q_submitted_cmd: 174
     ena_admin_q_completed_cmd: 174
     ena_admin_q_out_of_space: 0
     ena_admin_q_no_completion: 0

sudo ip -s -s link show eth0

2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 02:ab:cb:6f:d1:1a brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    287035161  218238   0       0       0       0
    RX errors: length   crc     frame   fifo    missed
               0        0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    6995515    65991    0       0       0       0
    TX errors: aborted  fifo   window heartbeat transns
               0        0       0       0       3

sudo ip -s link show tun-0A650024-0

8: tun-0A650024-0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 9000 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/gre 10.101.0.12 peer 10.101.0.36
    RX: bytes  packets  errors  dropped overrun mcast
    616        11       0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    616        11       0       0       0       0

sudo ip -s tun show tun-0A650024-0

tun-0A650024-0: gre/ip remote 10.101.0.36 local 10.101.0.12 ttl 255
RX: Packets    Bytes        Errors CsumErrs OutOfSeq Mcasts
    11         616          0      0        0        0
TX: Packets    Bytes        Errors DeadLoop NoRoute  NoBufs
    11         616          0      0        0        0

sudo cat /proc/net/xfrm_stat

XfrmInError             	0
XfrmInBufferError       	0
XfrmInHdrError          	0
XfrmInNoStates          	0
XfrmInStateProtoError   	0
XfrmInStateModeError    	0
XfrmInStateSeqError     	0
XfrmInStateExpired      	0
XfrmInStateMismatch     	0
XfrmInStateInvalid      	0
XfrmInTmplMismatch      	0
XfrmInNoPols            	0
XfrmInPolBlock          	0
XfrmInPolError          	0
XfrmOutError            	0
XfrmOutBundleGenError   	0
XfrmOutBundleCheckError 	0
XfrmOutNoStates         	0
XfrmOutStateProtoError  	0
XfrmOutStateModeError   	0
XfrmOutStateSeqError    	0
XfrmOutStateExpired     	0
XfrmOutPolBlock         	0
XfrmOutPolDead          	0
XfrmOutPolError         	0
XfrmFwdHdrError         	0
XfrmOutStateInvalid     	0
XfrmAcquireError        	0

sudo sar -n DEV 1 1

Linux 5.4.0-1084-aws (ip-10-101-0-12) 	11/23/2022 	_x86_64_	(2 CPU)

12:07:22 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
12:07:23 PM      gre0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM   gretap0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM tun-0A650024-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM tun-14FC2CA5-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM      ids0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM tun-14FC2B7A-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM tun-0FA5F0FD-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM tun-03064E0B-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM   erspan0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM      eth0      8.00      7.00      0.83      0.88      0.00      0.00      0.00      0.00
12:07:23 PM tun-0FA40E84-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM      ids1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM tun-2BCCF045-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:23 PM        lo     15.00     15.00      0.94      0.94      0.00      0.00      0.00      0.00
12:07:23 PM   ip_vti0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:         gre0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:      gretap0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-0A650024-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-14FC2CA5-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         ids0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-14FC2B7A-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-0FA5F0FD-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-03064E0B-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:      erspan0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         eth0      8.00      7.00      0.83      0.88      0.00      0.00      0.00      0.00
Average:    tun-0FA40E84-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         ids1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-2BCCF045-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:           lo     15.00     15.00      0.94      0.94      0.00      0.00      0.00      0.00
Average:      ip_vti0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

sudo sar -n EDEV 1 1

Linux 5.4.0-1084-aws (ip-10-101-0-12) 	11/23/2022 	_x86_64_	(2 CPU)

12:07:23 PM     IFACE   rxerr/s   txerr/s    coll/s  rxdrop/s  txdrop/s  txcarr/s  rxfram/s  rxfifo/s  txfifo/s
12:07:24 PM      gre0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM   gretap0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM tun-0A650024-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM tun-14FC2CA5-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM      ids0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM tun-14FC2B7A-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM tun-0FA5F0FD-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM tun-03064E0B-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM   erspan0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM      eth0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM tun-0FA40E84-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM      ids1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM tun-2BCCF045-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
12:07:24 PM   ip_vti0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

Average:        IFACE   rxerr/s   txerr/s    coll/s  rxdrop/s  txdrop/s  txcarr/s  rxfram/s  rxfifo/s  txfifo/s
Average:         gre0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:      gretap0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-0A650024-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-14FC2CA5-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         ids0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-14FC2B7A-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-0FA5F0FD-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-03064E0B-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:      erspan0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         eth0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-0FA40E84-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         ids1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:    tun-2BCCF045-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:      ip_vti0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

sudo cat /proc/net/softnet_stat

000047f2 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
0000db31 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

sudo mpstat -P all

Linux 5.4.0-1084-aws (ip-10-101-0-12) 	11/23/2022 	_x86_64_	(2 CPU)

12:07:24 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
12:07:24 PM  all    1.11    0.00    0.48    0.96    0.00    0.01    0.24    0.00    0.00   97.20


========================
Iteration: 38
2022-11-23:12:07:34
========================

<Snipped>
     ```


