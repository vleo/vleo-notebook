#!/usr/bin/perl
package MessMessage;
use strict;
use feature 'say';
use Exporter;
our @ISA=qw(Exporter); 
our @EXPORT=qw(new MT_CALL MT_RETURN MT_EVENT MT_REVENT MT_REVENT_CONFIRM MS_ORIG MS_OK MS_NOADDR MS_NOMETHOD MDST_BCAST SUBADDR_SELF);

use Data::UUID;

use constant MT_CALL => 'CALL';
use constant MT_RETURN => 'RET';
use constant MT_EVENT => 'EVENT';
use constant MT_REVENT => 'RELIABLE_EVENT'; # reliable event with confirmation
use constant MT_REVENT_CONFIRM => 'REVENT_CONFIRM'; # reliable event confirmation

use constant MF_TYPE => 'TYPE';
use constant MF_SRC => 'SRC';
use constant MF_SRCSUB => 'SRCSUB';
use constant MF_DEST => 'DEST';
use constant MF_DESTSUB => 'DESTSUB';
use constant MF_UUID => 'UUID';
use constant MF_UUIDORIG => 'UUIDORIG';
use constant MF_METHOD => 'METHOD';
use constant MF_ARGVAL => 'ARGVAL';
use constant MF_STATUS=> 'STATUS'; # message status

use constant MS_ORIG => "ORIG" ; # original message/event
# return statuses:
use constant MS_OK => "OK" ; # normal reply
use constant MS_NOADDR => "NOADDR" ; # can't deliver message - destinatin not found
use constant MS_NOMETHOD => "NOMETHOD" ; # can't deliver message - method unknown

use constant MDST_BCAST => '_BCAST_';
use constant SUBADDR_SELF => '_SELF_'; # message to/from MESS server proper (not clients)

sub new {
   my ($class,$type,$src,$srcsub,$dest,$destsub,$method,$argval,$status,$uuidorig) = @_;
   my $self={};
	 my $caller=caller;
	 die "unknown message type $type called by $caller " unless grep { $type eq $_ } (MT_CALL,MT_RETURN,MT_EVENT,MT_REVENT,MT_REVENT_CONFIRM);
   $self->{MF_TYPE}=$type; # message type: 

	 die "message src can't be empty" unless $src;
   $self->{MF_SRC}=$src; # source MESS server
	 die "message srcsub can't be empty" unless $srcsub;
   $self->{MF_SRCSUB}=$srcsub; # source client ID (tcClient or tcServer)
	 die "message dst can't be empty" unless $dest;
   $self->{MF_DEST}=$dest; # destinatin MESS server
	 die "message destsub can't be empty" unless $destsub;
   $self->{MF_DESTSUB}=$destsub; # destination client ID (tcClient or tcServer)
   $self->{MF_UUID}=undef; # this message UUID
	 die "message method can't be empty" unless $method;
   $self->{MF_METHOD}=$method; # method called by original message or event for one-way messages
   $self->{MF_ARGVAL}=$argval; # arguments

	 $status = MS_ORIG if grep { $type eq $_ } (MT_CALL,MT_EVENT,MT_REVENT);
	 die "unknown status $status called by $caller" unless grep { $status eq $_ } (MS_ORIG,MS_OK,MS_NOADDR,MS_NOMETHOD);
   $self->{MF_STATUS}=$status; # message status

	 die "uuid orig shall be empty for originating event, got $uuidorig" unless length($uuidorig)==0 and grep {$type eq $_} (MT_CALL,MT_EVENT,MT_REVENT);
	 die "uuid orig shall be specified and 36 char long for reply event, got $uuidorig" 
	   unless length($uuidorig)==36 and grep {$type eq $_} (MT_RETURN,MT_REVENT_CONFIRM);
   $self->{MF_UUIDORIG}=$uuidorig; # original message UUID, for reply messages (MT_RETURN,MT_REVENT_CONFIRM)

   my $uuid = new OSSP::uuid;
   $uuid->make("v1");
   $self->{'UUID'}=$uuid->export("str");

   bless $self,$class;
   return $self;
}

1;
