#!/bin/sh

file_list=/tmp/all_files_$(date +%y%m%d%H%M%S)

excludes=$(cat <<EOT
/home/sysadm/.local/share
/home/sysadm/.wine
/run
/proc
/sys
/dev
/media
/var/log
/var/spool
/var/cache
/tmp 
EOT
)

for p in $excludes
do
  cmd="$cmd -path $p -prune -o"
done

find / $cmd -type f -print > $file_list.lst

#sudo find / -path /home/sysadm/.local/share -prune -o -path /home/sysadm/.wine -prune -o -path /run -prune -o -path /proc -prune -o -path /sys -prune -o -path /dev -prune -o -path /media -prune -o -path /var/log -prune -o -path /var/spool -o -path /var/cache -prune -o -path /tmp -prune -o -type f -print > $file_list.lst

while read fn
do
  md5sum "$fn" >> $file_list.md5sum
done < $file_list.lst

