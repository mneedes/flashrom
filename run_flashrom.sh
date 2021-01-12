#!/bin/sh

# NOTE: Uses Flashrom utility from github

#
# Choose (uncomment) chip below
#

# 2MB Macronix (MXIC)
#CHIP="MX25R1635F"

# 4MB Macronix (MXIC)
#CHIP="MX25R3235F"

# 4MB XTX
#CHIP="XT25W32B"

FTDI_ARGS="-p ft2232_spi:type=4232H,port=B,divisor=8"

# Identify
if [ "$1" == "identify" ]; then
    sudo ./flashrom -VV $FTDI_ARGS
    exit 0
fi

if [ "$CHIP" == "" ]; then
    echo "Must specify CHIP before running script in erase/write mode"
    exit -1
fi

ARGS="$FTDI_ARGS -c $CHIP"

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

#sudo ./flashrom -p ft2232_spi:type=4232H,port=B,divisor=8 --layout rom.layout --image sector1 --read funXV.bin
#sudo ./flashrom -p ft2232_spi:type=4232H,port=B,divisor=8 --layout rom.layout --image sector1 --write funX.bin
#sudo ./flashrom -p ft2232_spi:type=4232H,port=B,divisor=16 -c XT25W32B --write READ1.bin
