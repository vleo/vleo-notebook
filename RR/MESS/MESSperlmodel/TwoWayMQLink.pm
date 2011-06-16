#!/usr/bin/perl
package TwoWayMQLink;

use strict;
use POSIX;
use POSIX::RT::MQ;

=pod
use Exporter;
our @ISA=qw(Exporter);
=cut

sub new {
   my ($class,$mqBaseName, $connectionType) = @_;
   my $self={};
	 my ($mqIN,$mqOUT);

	 if ( not defined($connectionType) or $connectionType eq 'normal')
	 {
		 # for reading (receive) message from "normal" prospective
	   $mqIN = $mqBaseName . "_IN";
		 # for writing (send) message from "normal" prospective
		 $mqOUT = $mqBaseName . "_OUT";
	 }
	 elsif ( $connectionType eq 'reverse')
	 {
		 # for reading (receive) message from "reversed" prospective
	   $mqIN = $mqBaseName . "_OUT";
		 # for writing (send) message from "reversed" prospective
		 $mqOUT = $mqBaseName . "_IN";
	 }
	 else
	 {
		 die "MQ connectin shall be specified as 'normal' (default) or 'reversed'\n";
	 };

	 my $attr = { mq_maxmsg  => 10, mq_msgsize =>  8192 };
   $self->{IN}= POSIX::RT::MQ->open($mqIN, O_RDWR|O_CREAT, 0600, $attr)
            or die "cannot open mq named $mqIN: $!\n";

   $self->{OUT}= POSIX::RT::MQ->open($mqOUT, O_RDWR|O_CREAT, 0600, $attr)
            or die "cannot open mq named $mqOUT: $!\n";

   bless $self,$class;
   return $self;
}

sub recvMsg
{
	my ($self) = @_;

	return $self->{IN}->receive();
}

sub sendMsg
{
	my ($self,$myMsg) = @_;
	$self->{OUT}->send($myMsg);
}

1;

