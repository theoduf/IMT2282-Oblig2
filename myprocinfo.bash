#!/bin/bash
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
	ctxt1=$(grep ctxt /proc/stat | awk '{print $2}')
	echo "."
	sleep 0.5
	echo ".."
	sleep 0.5
	echo "..."
        ctxt2=$(grep ctxt /proc/stat | awk '{print $2}')
        ctxt=$(($ctxt2 - $ctxt1))
	sleep 0.5
	echo "Antall Context switch'er det siste sekundet var: $ctxt"
}

function interrupts {
	ints=$(vmstat 1 2 | tail -1 | awk '{print $11}')
        echo "Antall interrupts det siste sekundet:  $ints"
}

function cpuTid {
	raw=( $(grep "cpu " /proc/stat) )
        userfirst=$((${raw[1]} + ${raw[2]}))
        kernelfirst=${raw[3]}
        echo "."
	sleep 0.5
	echo ".."
	sleep 0.5
	echo "..."
	raw=( $(grep "cpu " /proc/stat) )
        user=$(( $((${raw[1]} + ${raw[2]})) - $userfirst ))
        kernel=$(( ${raw[3]} - $kernelfirst ))
        sum=$(($kernel + $user))
        result="Andel av CPU-tiden siste sekund i usermode: \
        $((( $user*100)/$sum ))% \
 	 og i kernelmode: $((($kernel*100)/$sum ))%"
	sleep 0.5
	echo $result
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
