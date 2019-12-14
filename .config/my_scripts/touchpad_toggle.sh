TID=`xinput list | grep -i "ELAN" | egrep -o "id=[0-9]{1,2}" | egrep -o "[0-9]{1,2}"`
echo "Touchpad id: " $TID
ENABLED=`xinput list-props $TID | grep -i "device enabled" | egrep -o "[0-1]{1}$"`
echo "Device Enabled: " $ENABLED
if [ $ENABLED == "1" ]
then
	xinput disable $TID
	echo "Touchpad Disabled"
else
	xinput enable $TID
	echo "Touchpad Enabled"
fi
