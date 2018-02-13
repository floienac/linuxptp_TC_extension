#!/bin/bash
# setBridge.sh
# Setup a simple Ethernet bridge with iproute2

set -e

# print usage
usage() {
	echo -e "Usage: $0 -m <a|d> -n <bridge_name> [-i <interface>]\n
		\t-m: mode (a=add or d=delete)
		\t-n: bridge name (without space)
		\t-i: interfaces in the new bridge (mandatory if add mode selected)"
	1>&2
	exit 1
}

# get short options with or without parameters
while getopts ":m:n:i:" opts
do
	case "${opts}" in
		m)
			mode=${OPTARG}
			((s == 'a' || s == 'd')) || usage
			;;
		n)
			name=${OPTARG}
			;;
		i)
			interfaces+=(${OPTARG})
			;;
		*)
			usage
			;;
	esac
done
# move to next argument
shift $((OPTIND-1))

# check presence of mandatory arguments
if [ -z "${mode}" ] || [ -z "${name}" ]
then
	usage
fi

# do the tasks
if [ "$mode" == 'a' ]
then
	interfaces_nb=${#interfaces[@]}
    	if (( interfaces_nb < 2 ))
	then
		usage
	else
		echo -n "Setting up new bridge... "
		sudo ip link add name $name type bridge
		sudo ip link set $name up
		index=0
		while (( index < interfaces_nb ))
		do
			echo "index: $index, iface: ${interfaces[$index]}"
  			sudo ip link set ${interfaces[$index]} master $name
			((++index)) # ((index++)) does not work because returns 1 (set -e)
		done
		echo "Done"
	fi
elif [ "$mode" == 'd' ]
then
	echo -n "Deleting bridge $name... "
	sudo ip link delete $name type bridge
	echo "Deleted"
else
	usage
fi

# Check result of setup
echo "Bridge setup status:"
sudo bridge link

exit 0
