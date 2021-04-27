#!/usr/bin/env sh

#
# este script possibilita o upload de coletas de performance
# para analise pelos engenheiros da Acolita [https://acolita.com.br]
# caso necessite de ajuda para utiliza-lo, entre em contato conosco
#

if [ "$#" -lt 2 ]; then
	me=`basename "$0"`
	echo ""
    echo "usage: ${me} <filename> <company> <application:optional>"
	echo ""
	exit
fi

which curl
success=${?}

if [ ${success} -ne 0 ]; then
	apk add curl
fi

COMPANY=${2}

fullpath=`readlink -f ${1}`
filename=`basename ${fullpath}`

APPLICATION=${3:-Default}

URL="https://api.acolita.com.br/v1/file-upload"

BODY='{"company": "'${COMPANY}'", "application": "'${APPLICATION}'", "file": "'${filename}'"}'

api_path=`curl -H "Origin: https://acolita.com.br" "${URL}" -d "${BODY}"`
success=${?}

if [ ${success} -eq 0 ]; then
	##
	# remove double quotes from begin and end of variable
	api_path="${api_path%\"}"
	api_path="${api_path#\"}"
	##
	curl ${api_path} --upload-file ${fullpath}
	success=${?}
	if [ ${success} -eq 0 ]; then
		echo 'upload complete'
	else
		echo 'upload fail'
	fi
else
	echo 'fail to get api_path'
fi
