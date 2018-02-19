#!/bin/bash
while [ 1 ]
do
echo "Valg:{1|2|3|4|5|6|9}"
read svar
        case $svar in
		1)
                echo "Jeg er: $(whoami) Filen heter: $0"
		;;
		2)
		echo "Tid siden siste boot: $(uptime | awk '{print $3}')"
		;;
		3)
		echo "sakfjd"
		;;
		4)
		
		;;
		5)
		
		;;
		6)
		
		;;
		9)
		exit
		;;
		*)
		echo "Ikke et Gyldig valg"
		;;
	esac
done
