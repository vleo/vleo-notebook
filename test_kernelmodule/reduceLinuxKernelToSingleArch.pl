#!/usr/bin/perl

use 5.010;
use Cwd;
use File::Basename;
use strict;
our(@archList, @soundList);


initMe();
my $currentDir = getcwd;
my $backupDir = basename($currentDir).".arch_bak";
my $currentArchDir = "./arch";
my $currentSoundDir = "./sound";
my $backupArchDir = basename($currentDir).".arch_bak/arch";
my $backupSoundDir = basename($currentDir).".arch_bak/sound";

mkdir("../".$backupDir) or die unless -d "../".$backupDir;
mkdir("../".$backupArchDir) or die unless -d "../".$backupArchDir;
mkdir("../".$backupSoundDir) or die unless -d "../".$backupSoundDir;

for (@::archList)
{
  if(-d "../$backupArchDir/$_")
	 { system "mv ../$backupArchDir/$_ $currentArchDir" }
	else
	 { system "mv $currentArchDir/$_ ../$backupArchDir" }
}

for (@::soundList)
{
  if(-d "../$backupSoundDir/$_")
	 { system "mv ../$backupSoundDir/$_ $currentSoundDir" }
	else
	 { system "mv $currentSoundDir/$_ ../$backupSoundDir" }
}

sub initMe {
# for f in $(cat archList); do find -type d -name $f; done | grep -v Doc | sort
@::archList = qw(
alpha
arm
avr32
blackfin
cris
frv
h8300
m32r
m68k
m68knommu
microblaze
mips
mn10300
parisc
powerpc
s390
score
sh
sparc
um
xtensa
);
#ia64
#x86
@::soundList = qw(
aoa
arm
atmel
mips
parisc
ppc
sh
soc
sparc
spi
);
@::tools_perfList = qw(
arm
powerpc
s390
sh
sparc
);
@::driversList = qw(
net/arm
net/cris
scsi/arm
parisc
s390
sh
);
}
