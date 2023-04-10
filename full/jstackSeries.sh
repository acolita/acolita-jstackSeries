#!/bin/bash
# Adaptation of script from eclipse.org http://wiki.eclipse.org/How_to_report_a_deadlock#jstackSeries_--_jstack_sampling_in_fixed_time_intervals_.28tested_on_Linux.29


if [ $# -eq 0 ]; then
	echo >&2 "Usage: jstackSeries <pid> [ <count> [ <delay> ] ]"
	echo >&2 "    Defaults: count = 10, delay = 1 (seconds)"

	echo ""
	echo "Running Java Programs"
	echo ""
	jps -vl | grep -v "sun.tools.jps.Jps" | awk 'BEGIN { print "Command \t Pid" } { print $2 " \t " $1 }'
	exit 1
fi

pid=$1           # required
count=${2:-300}  # defaults to 300 times
delay=${3:-1}    # defaults to 1 second

total=$count

basic_info_file=basic_info.$(date +%s.%N).txt

echo "kernel" >> ${basic_info_file}
uname -a >> ${basic_info_file}
echo "" >> ${basic_info_file}

echo "hostname" >> ${basic_info_file}
uname -n >> ${basic_info_file}
echo "" >> ${basic_info_file}

echo "architecture" >> ${basic_info_file}
uname --m >> ${basic_info_file}
echo "" >> ${basic_info_file}

echo "devices basic" >> ${basic_info_file}
lshw -short >> ${basic_info_file}
echo "" >> ${basic_info_file}

while [ $count -gt 0 ]
do
	jstack -l $pid > jstack.$pid.$(date +%s.%N)
	top -H -b -n1 -p $pid > top.$pid.$(date +%s.%N)
	sleep $delay
	let count--
	
	percentage=$(((100*(total-count))/total))
    echo -en "\r$(printf "%*s" "$percentage" '' | tr ' ' '#') $percentage%"
done

zip jstack-collect-$(date +%s.%N).zip jstack.$pid.* top.$pid.* basic_info.*
rm -r jstack.$pid.* top.$pid.* basic_info.*
