#find -type f -name \*.tst | cpio -oav > ../x.cpio; cpio -tv < ../x.cpio
#find -type f -name \*.tst -print0 | cpio -o0av > ../x.cpio; cpio -tv < ../x.cpio
rm all_files_checksums.lst
find -name \*.tst -exec ./test_sh_param1.sh {}  \;
