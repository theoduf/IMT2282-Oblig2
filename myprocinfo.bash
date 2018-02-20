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
clear
while [ 1 ]
do
echo "Valg:{1|2|3|4|5|6|9}"
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
		echo "(WIP)"
		;;
		5)
		clear
		echo "(WIP)"
		;;
		6)
		clear
		echo "(WIP)"
		;;
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
