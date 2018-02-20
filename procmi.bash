#!/bin/bash
#*
#* Copyright (c) 2018 Theodor Hoff <theodorhoff@hotmail.com>
#*
#* Permission to use, copy, modify, and/or distribute this software for any
#* purpose with or without fee is hereby granted, provided that the above
#* copyright notice and this permission notice appear in all copies.
#*
#* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#* ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#* ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#* OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

function fileWrite {
	currentDate=$(date +%Y%m%d-%H:%M:%S)
	fileName="$pid-$currentDate.meminfo"
	touch $fileName
	echo "******** Minneinfo om prosess med PID $pid ********" > $fileName
	echo "Total bruk av virtuelt minne (VmSize):	$VmSize KB" >> $fileName
	echo "Mengde private virtuelt minne (VmData+VmStk+VmExe):	$VmPriv KB" >> $fileName
	echo "Mengde shared virtuelt minne (VmLiB):	$VmLib KB" >> $fileName
	echo "Total bruk av fysisk minne (VmRSS):	$VmRSS KB" >> $fileName
	echo "Mengde fysisk minne som benyttes til page table (VmPTE):	$VmPTE KB" >> $fileName
}

for pid in $@; do	#Take any number of inputs via CLI parameters and do what needs to be done
	if [[ -e /proc/$pid/status && -r /proc/$pid/status ]]; then	# -r if read permissioni
		status=$(cat /proc/$pid/status)
		VmSize=$(echo "$status" | grep VmSize | awk '{print $2}') # Total VmSize reserved, including space for VmData and VmStk to grow
		VmPriv=$(echo "$status" | egrep 'Vm[DSE][atx]' | awk '{print $2}' | sed ':a;N;$!ba;s/\n/+/g' | bc ) # http://unix.stackexchange.com/questions/114943/can-sed-replace-new-line-characters
		VmLib=$(echo "$status" | grep VmLib | awk '{print $2}')
		VmRSS=$(echo "$status" | grep VmRSS | awk '{print $2}')
		VmPTE=$(echo "$status" | grep VmPTE | awk '{print $2}')
		fileWrite
	else
		echo "Prosess med PID $pid finnes ikke, eller du har ikke leserettigheter."
	fi
done
