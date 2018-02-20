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
function context {
	ctext1=$(cat /proc/stat | grep ctxt | cut -f 2 -d " ");
	sleep 1;
	ctext2=$(cat /proc/stat | grep ctxt | cut -f 2 -d " ");
	ctext=$(($ctext2 - $ctext1))
	echo "Det var: $ctext content switch'er det siste sekundet"
}

function interrupts {
	interrupt1=$(cat /proc/stat | grep intr | sed -e 's/intr //g' -e 's/ /+/g' | bc)
	sleep 1;
	interrupt2=$(cat /proc/stat | grep intr | sed -e 's/intr //g' -e 's/ /+/g' | bc)
	interrupt=$(($interrupt2-$interrupt1))
	echo "Antall interrupts siste sekund: $interrupt"
}

function cpuTid {
	stat1=$(cat /proc/stat | head -n 1 | sed 's/cpu  //g')
	sleep 1;
	stat2=$(cat /proc/stat | head -n 1 | sed 's/cpu  //g')

	totalCPU=$(($(echo $stat2 | sed 's/ /+/g' | bc)-$(echo $stat1 | sed 's/ /+/g' | bc)))
	kernel=$(($(echo $stat2 | awk '{print $3}')-$(echo $stat1 | awk '{print $3}')))
	user=$(($(echo $stat2 | awk '{print $1}')-$(echo $stat1 | awk '{print $1}')))
	echo $(echo "scale=2;($kernel*100/$totalCPU)" | bc) \% av cputiden brukes i kernelmode
	echo $(echo "scale=2;($user*100/$totalCPU)" | bc) \% av cputiden brukes i usermode
}

clear
while [ 1 ]
do
echo "Valg:
	1|Hvem er jeg og hva er navnet på dette scriptet?
	2|Hvor lenge er det siden siste boot?
	3|Hvor mange prosesser og tråder finnes?
	4|Hvor mange Context switch'er fant sted siste sekund?
	5|Hvor stor andel av CPU-tiden ble benyttet i kernelmode og usermode siste sekund?
	6|Hvor mange interrups fant sted siste sekund?
	9|Avslutt."

echo "-"
read svar
        case $svar in
		1)
                clear
		echo "Jeg er: $(whoami) Filen heter: $0"
		;;
		2)
		clear
		echo "Tid siden siste boot: $(uptime | awk '{print $3}')"
		;;
		3)
		p=$(ps ax | wc -l)
                t=$(ps amx | wc -l)
                clear
		echo "Det finnes: $p prosesser og $t tråder."
		;;
		4)
		clear
		context;;
		5)
		clear
		cpuTid;;
		6)
		clear
		interrupts;;
		9)
		clear
		exit
		;;
		*)
		clear
		echo "Ikke et Gyldig valg"
		;;
	esac
done
