#!/usr/bin/env -S sh

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
        echo $usageMessage
		exit
	fi
	# validate max
	if [ $# -eq 5 ];then
		maxArgs=$5
		if [ $argsCount -gt $maxArgs ]; then
		    echo Too many arguments!
			echo $usageMessage
			exit
		fi
	fi
}

# checksFor <utilitaryToCheck>
checksFor(){
	utilitary=$1
	nul=`which $utilitary`
	success=${?}

	if [ ${success} -ne 0 ]; then
		echo
		echo "$utilitary not found, try one of these commands to install it"
		echo
		echo " apk add $utilitary"
		echo " apt install $utilitary"
		echo " yum install $utilitary"
		echo

		exit
	fi
}

# curlRequisition <fullFilePath> <origin:optional>
api2Upload(){
	FULLPATH=$1
	ORIGIN=${2:-"https://acolita.com.br"}

	id="" # id is passed through fuctions
	api2Post $FULLPATH $ORIGIN
	api2Put $FULLPATH
}

# api2Post <fullFilePath> <origin:optional>
api2Post(){
	FULLPATH=$1
	ORIGIN=${2:-"https://acolita.com.br"}

	URL='https://api2.acolita.com.br/file/reserve'

	FILENAME=`basename ${FULLPATH}`

	now=`date "+%Y-%m-%d"`
	body="acolita/api2-upload/${now}/${FILENAME}"
	response=`curl -f -s -w " %{http_code}" -H "Origin: ${ORIGIN}" "${URL}" -d ${body}`
	success=${?}

	# expand response to positional parameters
	set -- $response

	# if all right, this is an uuid
	id=$1

	# drops the first n-1 positional parameters
	shift $(( $# - 1 ))
	
	statusCode=$1

	##
	# checks if statusCode starts with a 2
	case $statusCode in 
	2*)
	    ;;
	*)
	    echo 'Reponse error, status code: '$statusCode
		exit
	    ;;
	esac
	##

	if [ ${success} -eq 0 ]; then
		echo 'success to post'
	else
		echo 'fail to get api2 id'
		exit
	fi
}

# api2Put <fullFilePath>
api2Put(){
	FULLPATH=$1
	URL="https://api2.acolita.com.br/file/$id/upload"
	curl -f -s -H "Origin: ${ORIGIN}" "${URL}" --upload-file ${FULLPATH}
	success=${?}
	if [ ${success} -eq 0 ]; then
		echo 'success to put'
		echo 'upload complete'
		echo "download link: https://api2.acolita.com.br/file/$id/download"
	else
		echo 'upload fail'
	fi
}

validateArgsCount $0 $# "usage: `basename $0` <filename>" 1 1

checksFor curl

fullpath=`readlink -f ${1}`

api2Upload $URL ${fullpath} 
