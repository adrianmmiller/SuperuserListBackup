#!/system/bin/sh
LogFile="/storage/emulated/0/SuperUserListBackup.log"
ListFile="/storage/emulated/0/SuperUserList.txt"

if [ ! -f "$LogFile" ]; then
    touch "$LogFile"
fi

ui_print "Backup of Magisk SuperUser List: Starting..." 2>&1 | tee -a $LogFile

#query magisk.db policies table, cut UID from return and convert to a single space delimited line
uids=$(magisk --sqlite "SELECT * FROM policies;" | cut -f5 -d '=' | cut -f1 -d '|' | xargs | sed -e 's/ / /g')
for x in $uids
do
#query package list using uid to find package name and format result as just package name
pm list packages --uid $x | cut -f2 -d ":" | cut -f1 -d " " 
# write packages list to backup file
done > "$ListFile"

if [ $? -eq 0 ] ;	then
		ui_print "SuperUserList.txt: written to sdcard successfully" 2>&1 | tee -a $LogFile
		ui_print "Backup of Magisk SuperUser List: Complete" 2>&1 | tee -a $LogFile
	else
		ui_print "SuperUserList.txt: NOT written to sdcard" 2>&1 | tee -a $LogFile
		ui_print "Backup of Magisk SuperUser List: NOT Complete" 2>&1 | tee -a $LogFile
fi
