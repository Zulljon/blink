#!bin/bash

	UTC_TIME="$(date +%Y-%m-%d-%R)"
	#date +%Y-%m-%d-%R | ${UTC_TIME}
	NAME_LOG_FILE="build_${UTC_TIME}.log"
	make -k 2>&1 | tee ${NAME_LOG_FILE}
	mkdir -p log
	cp -R ${NAME_LOG_FILE} log/${NAME_LOG_FILE}
	rm ${NAME_LOG_FILE}
	#echo $UTC_TIME
	#echo $NAME_LOG_FILE