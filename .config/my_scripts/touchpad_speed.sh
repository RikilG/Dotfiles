#!/bin/bash

# to increase mouse pointer speed
# to rewrite, first run "xinput list" and note down the id of touchpad
# in my case it is 14.(id=14)
# run "xinput list-props 14" and note down the id(in brackets) of Coordinate Transformation Matrix (153 or 154 in my case)(so changing both)
# theese values correspond to identity matrix where first 1 is x and second 1 is y. just increment theese values only and test
#xinput set-prop 14 153 2.400000, 0.000000, 0.000000, 0.000000, 2.400000, 0.000000, 0.000000, 0.000000, 1.000000
#xinput set-prop 14 154 2.400000, 0.000000, 0.000000, 0.000000, 2.400000, 0.000000, 0.000000, 0.000000, 1.000000

ID=`xinput list | grep Touchpad | grep -oEi 'id=[0-9][0-9]' | grep -o '[0-9][0-9]'`
echo $ID
PROPID=`xinput list-props $ID | grep -i transformation | grep -oEi '[0-9]{3}\)' | grep -oE '[0-9]{3}'`
echo $PROPID
xinput set-prop $ID $PROPID 2.600000, 0.000000, 0.000000, 0.000000, 2.600000, 0.000000, 0.000000, 0.000000, 1.000000
