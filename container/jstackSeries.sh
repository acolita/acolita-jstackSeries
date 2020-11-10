#!/bin/bash
# Adaptation of script from eclipse.org http://wiki.eclipse.org/How_to_report_a_deadlock#jstackSeries_--_jstack_sampling_in_fixed_time_intervals_.28tested_on_Linux.29

if [ ${#} -eq 0 ]; then
	echo >&2 "Usage: jstackSeries <pid> [ <count> [ <delay> ] ]"
	echo >&2 "    Defaults: count = 10, delay = 1 (seconds)"

	echo ""
	echo "Running Java Programs"
	echo ""
	jps -vl | grep -v "sun.tools.jps.Jps" | awk 'BEGIN { print "Command \t Pid" } { print $2 " \t " $1 }'
	exit 1
fi

pid=${1}           # required
count=${2:-300}  # defaults to 300 times
delay=${3:-1}    # defaults to 1 second

while [ ${count} -gt 0 ]
do
	filename=jstack.${pid}.`date -Is | tr ':T' '-'`
	jstack -l ${pid} > ${filename}
	sleep ${delay}
	let count--
	echo -n "."
done

filename=jstack-collect-`date -Is | tr ':T' '-'`.tar.bz2
tar cjf ${filename} jstack.${pid}.*
rm -r jstack.${pid}.*
