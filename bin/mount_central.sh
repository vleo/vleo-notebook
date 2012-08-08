#!/bin/sh
###### options processing ######
TEMP=`getopt -o cnsuh -n 'test_getopt.sh' -- "$@"`

if [ $? != 0 ] ; then TEMP="-h --" ; fi
eval set -- "$TEMP"
while true ; do
        case "$1" in
# change options here according to your needs
           -c ) shift; opt_c=1 ;;
           -n ) shift; opt_n=1 ;;
           -s ) shift; opt_s=1 ;;
           -u ) shift; opt_u=1 ;;
# change USAGE text (help) below
           -h ) cat <<EOT
Usage: $0 [-c] [-n] [-s]
Options:
  -c     /central
  -n     /newscratch (md0)
  -s     shaytan home
  -h     this help
EOT
                shift; exit;;
           --) shift ; break ;;
        esac
done
# change to check YOUR options consistency here
if [ ! \( -n "$opt_c" -o -n "$opt_n" -o -n "$opt_s" \) ]
then
  echo Must specify at least one option
  $0 -h
  exit
fi
###### end of options processing ######

if [ -n "$opt_c" ] ; then
  if [ ! -n "$opt_u" ]
  then
    vgscan 
    vgchange -a y newspace && mount /dev/mapper/newspace-newscratch /central/
  else
    umount /central && vgremove newspace
  fi
fi

if [ -n "$opt_n" ] ; then
  if [ ! -n "$opt_u" ]
  then
    mount /dev/md0 /newscratch
  else
    umount /newscratch
  fi
fi

if [ -n "$opt_s" ] ; then
  if [ ! -n "$opt_u" ]
  then
  sshfs vleo@shaytan: /home/vleo/shaytan -o allow_other
  else
  umount /home/vleo/shaytan
  fi
fi
