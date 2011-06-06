#!/usr/bin/perl
package MessEvent;

use strict;
use Data::UUID;

sub new {
   my ($src,$class,$dest,$method,$argval,$retval) = @_;
   my $self={};
   $self->{'SRC'}=$src;
   $self->{'DEST'}=$dest;
   $self->{'UUID'}=undef;
   $self->{'METHOD'}=$method;
   $self->{'ARGVAL'}=$argval;
   $self->{'RETVAL'}=$retval;

   my $uuid = new OSSP::uuid;
   $uuid->make("v1");
   $self->{'UUID'}=$uuid->export("str");

   bless $self,$class;
   return $self;
}

1;

package CallEventData;

use strict;
use FreezeThaw qw(freeze thaw);
use Data::Dumper;

=pod
use Exporter;

our @ISA=qw(Exporter); 

our @EXPORT=qw(
&listenOnPort
&connectToAddr
);
=cut

sub new {
   my $class = shift;
   my $self={};
   $self->{'RAW'}=undef;
   $self->{'FROZEN'}=undef;
   bless $self,$class;
   return $self;
}

sub setRaw {
   my ($self,$rawData)=@_;
   $self->{'RAW'}=$rawData;
   $self->{'FROZEN'}=freeze $rawData;
   return 0;
}

sub setFrozen {
   my ($self,$v)=@_;
   $self->{'FROZEN'}=$v;
   ($self->{'RAW'})=thaw $v;
   return 0;
}

sub getRaw {
   my $self = shift;
   return $self->{'RAW'};
}

sub getFrozen {
   my $self = shift;
   return $self->{'FROZEN'};
}

sub receiveData {
   my ($self,$sock) = @_;
   my $oneByte;
   my $len;
   print "receiveData( ",ref($self),"->",$self," , ", ref($sock),"->",$sock," )\n";

   noZero:
   $len=read($sock,$oneByte,1);
   return -1 if $len == 0;
   $oneByte=unpack("C",$oneByte);
   printf "0x%02x ",$oneByte;
   if($oneByte != 0x00)
     { goto noZero; }

   read($sock,$oneByte,1);
   $oneByte=unpack("C",$oneByte);
   printf "0x%02x ",$oneByte;
   if($oneByte != 0x00)
     { goto noZero; }

   read($sock,$oneByte,1);
   $oneByte=unpack("C",$oneByte);
   printf "0x%02x ",$oneByte;
   if($oneByte == 0x01)
     { goto gotNALstart; }
   if($oneByte != 0x00)
     { goto noZero; }

   leadingZeros:
   $len=read($sock,$oneByte,1);
   return -1 if $len == 0;
   $oneByte=unpack("C",$oneByte);
   printf "0x%02x ",$oneByte;
   if($oneByte == 0x00)
     { goto leadingZeros; }
   if($oneByte == 0x01)
     { goto gotNALstart; }
   goto noZero;

   gotNALstart:
   my $packLenBuf;
   my $packLen;
   read($sock,$packLenBuf,4);
   $packLen = unpack("N",$packLenBuf);
   printf "reading pack of %d bytes:\n",$packLen;
   my $body;
   read($sock,$body,$packLen);
   # remove 0x03 combinations from $body
   $body =~ s/\000\000\003/\000\000/gs;
   $body =~ s/\003$//s;
   $self->setFrozen($body);
}

sub sendData {
   my ($self,$sock) = @_;
   my $coded = $self->{'FROZEN'};
   # \000 \000 \000  => \000 \000 \003 \000
   # \000 \000 \001  => \000 \000 \003 \001
   # \000 \000 \002  => \000 \000 \003 \002
   # \000 \000 \003  => \000 \000 \003 \003

   $coded =~ s/\000\000(\000|\001|\002|\003)/\000\000\003$1/gs;
   my $packLen;
   $packLen=pack("N",length($coded));
   printf "writing pack of %d bytes:\n",unpack("N",$packLen);
   print $sock "\000\000\000\001",$packLen,$coded,"\003";

}

sub printDumper {
   my $self = shift;
   print Dumper($self);
}

1;
