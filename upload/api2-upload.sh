#!/usr/bin/env sh

#
# este script possibilita o upload de coletas de performance
# para analise pelos engenheiros da Acolita [https://acolita.com.br]
# caso necessite de ajuda para utiliza-lo, entre em contato conosco
#

# validateArgsCount $0 $# <usageMessage> <minArgs> <maxArgs:optional> 
validateArgsCount(){
	fileName=$1
	argsCount=$2
	usageMessage=$3
	minArgs=$4
	# validating the own function args
	if [ $# -lt 3 ]; then
		echo 'validateArgsCount $0 $# <usageMessage> <minArgs> <maxArgs:optional>'
		exit
	fi
	if [ $# -gt 5 ]; then
		echo 'validateArgsCount $0 $# <usageMessage> <minArgs> <maxArgs:optional>'
		exit
	fi
	# validate min
	if [ $argsCount -lt $minArgs ]; then
		echo Arguments missing!
        echo usageMessage
		exit
	fi
	# validate max
	if [ $# -eq 5 ];then
		maxArgs=$5
		if [ $argsCount -gt $maxArgs ]; then
		    echo Too many arguments!
			echo usageMessage
			exit
		fi
	fi
}

# checksFor <utilitaryToCheck>
checksFor(){
	utilitary=$1
	which $utilitary
	success=${?}

	if [ ${success} -ne 0 ]; then
		apk add $utilitary
	fi
}

# curlRequisition <url> <body> <fullFilePath> <origin:optional>
curlUpload(){
	URL=$1
	BODY=$2
	FULLPATH=$3
	ORIGIN=${4:-"https://acolita.com.br"}

	api_path=`curl -H "Origin: ${ORIGIN}" "${URL}" -d "${BODY}"`
	success=${?}

	if [ ${success} -eq 0 ]; then

		##
		# remove double quotes from begin and end of variable
		api_path="${api_path%\"}"
		api_path="${api_path#\"}"
		##

		curl ${api_path} --upload-file ${FULLPATH}
		success=${?}
		if [ ${success} -eq 0 ]; then
			echo 'upload complete'
		else
			echo 'upload fail'
		fi
	else
		echo 'fail to get api_path'
	fi
}

validateArgsCount $0 $# "usage: ${me} <filename> <company> <application:optional>" 2 3

checksFor curl

COMPANY=${2}

fullpath=`readlink -f ${1}`
filename=`basename ${fullpath}`

APPLICATION=${3:-Default}

URL="https://api2.acolita.com.br/file-upload"

BODY='{"company": "'${COMPANY}'", "application": "'${APPLICATION}'", "file": "'${filename}'"}'

curlUpload $URL $BODY ${fullpath} 
