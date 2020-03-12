#!/bin/sh

# Uses Flashrom utility from github, chip definitions at bottom of file

#sudo ./flashrom -p ft2232_spi:type=4232H,port=B,divisor=8 --layout rom.layout --image sector1 --read funXV.bin
#sudo ./flashrom -p ft2232_spi:type=4232H,port=B,divisor=8 --layout rom.layout --image sector1 --write funX.bin
#sudo ./flashrom -p ft2232_spi:type=4232H,port=B,divisor=16 -c XT25W32B --write READ1.bin

FTDI_ARGS="-p ft2232_spi:type=4232H,port=B,divisor=8"
CHIP="-c MX25R3235F"
#CHIP="-c XT25W32B"
ARGS="$FTDI_ARGS $CHIP"

# Identify
if [ "$1" == "identify" ]; then
    sudo ./flashrom -VV $FTDI_ARGS
fi

# Erase
if [ "$1" == "erase" ]; then
    sudo ./flashrom $ARGS --erase
    sudo ./flashrom $ARGS --read ERASE1.bin
    xxd ERASE1.bin > ERASE1.bin.txt
    grep -v "ffff ffff ffff ffff ffff ffff ffff ffff" ERASE1.bin.txt
fi

# Write
if [ "$1" == "write" ]; then
    sudo ./flashrom $ARGS --write $2
    sudo ./flashrom $ARGS --read READ1.bin
    diff READ1.bin $2
fi
