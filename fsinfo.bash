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
if [[ -d $1 ]]; then
	full=$(df -h $1| tail -n 1 | awk '{print $5}')
	filer=$(find $1 -depth -type f | wc -l)
	stoerst=$(find $1 -depth -type f | tr '\n' '\0' | du -ah --files0-from=- | sort -h | tail -n 1)       # largest file, <fileSize> <fileName>
	totalStr=$(find $1 -depth -type f | tr '\n' '\0' | du -a --files0-from=- | awk '{print $1}' | sed ':a;N;$!ba;s/\n/+/g' | bc)
	gjennomsnitt=$(($totalStr/$filer))
	hardLinks=$(find $1 -depth -type f -print0 | xargs --null ls -la | awk '{print $2 , $9 }' | sort | tail -n 1)

	echo "Partisjonen $1 befinner seg på er $full full"
	echo "Det finnes $filer filer"
	echo "Den største er $(echo $stoerst | awk '{print $2'}) som er $(echo $stoerst | awk '{print $1}') stor."
	echo "Gjennomsnittlig filstørrelse er ca $gjennomsnitt bytes."
	echo "Filen $(echo $hardLinks | awk '{print $2}') har flest hardlinks, den har $(echo $hardLinks | awk '{print $1}')."
else
	echo "$1 er ikke et directory..."
fi
