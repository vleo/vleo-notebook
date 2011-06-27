#!/usr/bin/perl
package MessMessage;
use strict;
use feature 'say';
use Exporter;
our @ISA=qw(Exporter); 
our @EXPORT=qw(new MT_CALL MT_RET MT_EVENT MT_REVENT MT_REVENT_CONFIRM MS_ORIG MS_OK MS_NOADDR MS_NOMETHOD DST_BCAST SUBADDR_SELF);

use Data::UUID;

use constant MT_CALL => 'CALL';
use constant MT_RET => 'RET';
use constant MT_EVENT => 'EVENT';
use constant MT_REVENT => 'RELIABLE_EVENT'; # reliable event with confirmation
use constant MT_REVENT_CONFIRM => 'REVENT_CONFIRM'; # reliable event confirmation

# STATUSES
use constant MS_ORIG => "ORIG" ; # original message/event
use constant MS_OK => "OK" ; # normal reply
use constant MS_NOADDR => "NOADDR" ; # can't deliver message - destinatin not found
use constant MS_NOMETHOD => "NOMETHOD" ; # can't deliver message - method unknown

# special ADDRESSES
use constant DST_BCAST => '_BCAST_';
use constant SUBADDR_SELF => '_SELF_'; # message to/from MESS server proper (not clients)

my @FIELDS=qw(TYPE SRC SRCSUB DST DSTSUB UUID UUIDORIG METHOD ARGVAL STATUS);

foreach my $f (@FIELDS)
{
	no strict;
	*{"MessMessage\::MF_$f"} = \&{sub{$f}};
	*{"MessMessage\::get_$f"} =  \&{sub { my $self=shift; $self->{$f}; }};
	*{"MessageTransport\::get_$f"} =   \&{sub { my $self=shift; $self->{RAW}->{$f}; }};
	push @EXPORT, "get_$f";
}

sub new {
   my ($class,$type,$srcsub,$src,$dstsub,$dst,$method,$argval,$status,$uuidorig) = @_;
   my $self={};
	 my $caller=caller;
	 die "unknown message type $type called by $caller " unless grep { $type eq $_ } (MT_CALL,MT_RET,MT_EVENT,MT_REVENT,MT_REVENT_CONFIRM);
   $self->{&MF_TYPE}=$type; # message type: 

	 die "message src can't be empty" unless $src;
   $self->{&MF_SRC}=$src; # source MESS server
	 die "message srcsub can't be empty" unless $srcsub;
   $self->{&MF_SRCSUB}=$srcsub; # source client ID (tcClient or tcServer)
	 die "message dst can't be empty" unless $dst;
   $self->{&MF_DST}=$dst; # destinatin MESS server
	 die "message dstsub can't be empty" unless $dstsub;
   $self->{&MF_DSTSUB}=$dstsub; # destination client ID (tcClient or tcServer)
   $self->{&MF_UUID}=undef; # this message UUID
	 die "message method can't be empty" unless $method;
   $self->{&MF_METHOD}=$method; # method called by original message or event for one-way messages
   $self->{&MF_ARGVAL}=$argval; # arguments

	 $status = MS_ORIG if grep { $type eq $_ } (MT_CALL,MT_EVENT,MT_REVENT);
	 die "unknown status $status called by $caller" unless grep { $status eq $_ } (MS_ORIG,MS_OK,MS_NOADDR,MS_NOMETHOD);
   $self->{&MF_STATUS}=$status; # message status

	 if (length($uuidorig)==0 and grep {$type eq $_} (MT_CALL,MT_EVENT,MT_REVENT) or
	     length($uuidorig)==36 and grep {$type eq $_} (MT_RET,MT_REVENT_CONFIRM) )
	 {
		 $self->{&MF_UUIDORIG}=$uuidorig; # original message UUID, for reply messages (MT_RETURN,MT_REVENT_CONFIRM)
	 }
	 else
	 {
	   die "uuid orig shall be empty for originating event (MT_CALL,MT_EVENT,MT_REVENT) or".
	       "uuid orig shall be specified and 36 char long for reply event(MT_RETURN,MT_REVENT_CONFIRM), got type $type and uuid='$uuidorig'" 
	 };

   my $uuid = new OSSP::uuid;
   $uuid->make("v1");
   $self->{&MF_UUID}=$uuid->export("str");

   bless $self,$class;
   return $self;
}


1;
