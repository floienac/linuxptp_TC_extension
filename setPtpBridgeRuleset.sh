#!/bin/bash

#
# Flush all current rules from ebtables
#
 nft flush ruleset
#
# Add table and important chains
#
 nft add table bridge ptp_table
 nft add chain bridge ptp_table INPUT { type filter hook input priority 0 \; policy accept \; }
 nft add chain bridge ptp_table FORWARD { type filter hook forward priority 0 \; policy accept \; }
#
# Add rules to FORWARD chain to prevent some PTP message to be duplicated
#
 nft add rule bridge ptp_table FORWARD ether daddr 01:80:C2:00:00:0E drop
 nft add rule bridge ptp_table FORWARD ether daddr 01:1B:19:00:00:00 drop
#
# Print the result
#
 nft list ruleset -a
