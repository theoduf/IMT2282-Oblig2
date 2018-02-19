#!/bin/bash
clear


function contextSwitch {
	{
	ctxt1=$(grep ctxt /proc/stat | awk '{print $2}')
        echo 50
	sleep 1
        ctxt2=$(grep ctxt /proc/stat | awk '{print $2}')
        ctxt=$(($ctxt2 - $ctxt1))
        result="Antall Context switch'er det siste sekundet var: $ctxt"
	echo $result > result
	} | whiptail --gauge "Venter på resultat ..." 6 60 0
}



function userKernelMode {
	{
	raw=( $(grep "cpu " /proc/stat) )
        userfirst=$((${raw[1]} + ${raw[2]}))
        kernelfirst=${raw[3]}
	echo 50
        sleep 1
	raw=( $(grep "cpu " /proc/stat) )
        user=$(( $((${raw[1]} + ${raw[2]})) - $userfirst ))
	echo 90
        kernel=$(( ${raw[3]} - $kernelfirst ))
        sum=$(($kernel + $user))
        result="Andel av CPU-tiden siste sekund i usermode: \
        $((( $user*100)/$sum ))% \
        \nog i kernelmode: $((($kernel*100)/$sum ))%"
	echo $result > result
	echo 100
	} | whiptail --gauge "Venter på resultat ..." 6 60 0
}

function interupts {
	{
	ints=$(vmstat 1 2 | tail -1 | awk '{print $11}')
        result="Antall interrupts det siste sekundet:  $ints"
	echo 100
	echo $result > result
	} | whiptail --gauge "Venter på resultat ..." 6 60 50
}
while [ 1 ]
do
CHOICE=$(
whiptail --title "Operativsystemer" --menu "Velg valgt valg" 16 100 9 \
	"1)" "Hvem er jeg og hva er navnet på dette scriptet?"   \
	"2)" "Hvor lenge er det siden siste boot?"  \
	"3)" "Hvor mange prosesser og tråder finnes?" \
	"4)" "Hvor mange context switch'er fant sted siste sekund?" \
	"5)" "Hvor stor andel av CPU-tiden ble benyttet i kernelmode og i usermode siste sekund?" \
	"6)" "Hvor mange interrupts fant sted siste sekund?" \
	 3>&2 2>&1 1>&3
)


case $CHOICE in
	"1)")
		result="Jeg er $(whoami), scriptes navn er $0"
	;;

	"2)")
	        OP=$(uptime | awk '{print $3;}')
		result="Siden siste boot er det $OP Timer:Minutter"
	;;

	"3)")
	        p=$(ps ax | wc -l)
                t=$(ps amx | wc -l)
		result="Det finnes: $p prosesser\nog $t tråder."
        ;;

	"4)")
	        contextSwitch
		read -r result < result
        ;;

	"5)")
                userKernelMode
		read -r result < result
        ;;

	"6)")
		interupts
		read -r result < result
        ;;

	*)
		exit
	;;
esac
whiptail --msgbox "$result" 20 78
done
exit
