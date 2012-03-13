sudo vmware-mount -f /home/vleo/vmware/Centos6.0-juridoc/Centos6.0-juridoc.vmdk /home/vleo/tmp/shaytan
sudo losetup /dev/loop0 /home/vleo/tmp/shaytan/flat 
sudo fdisk -l /dev/loop0
echo $((1026048*512))
sudo losetup -d /dev/loop0
sudo losetup /dev/loop0 /home/vleo/tmp/shaytan/flat -o525336576
sudo pvscan
sudo vgchange -a y vg_juridoc
ls /dev/mapper/
sudo mount /dev/mapper/vg_juridoc-lv_root /home/vleo/tmp/juridoc_nfs
ls /home/vleo/tmp/juridoc_nfs
echo -n "VM LV mounted; prese ENTER to unmount"; read
sudo umount /home/vleo/tmp/juridoc_nfs
sudo vgchange -a n vg_juridoc
sudo losetup -d /dev/loop0
sudo vmware-mount -d /home/vleo/tmp/shaytan/
