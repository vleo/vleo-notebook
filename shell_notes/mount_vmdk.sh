#!/bin/sh

 if [ -d reflection_mnt/boot -o -d reflection_min_mnt/boot ]
 then
 echo Unmounting...
 vmware-mount -d reflection_mnt
 vmware-mount -d reflection_min_mnt
 else
 echo Mounting...
 vmware-mount reflection.vmdk 1 reflection_mnt
 vmware-mount reflection.vmdk 4 reflection_min_mnt/
 fi
