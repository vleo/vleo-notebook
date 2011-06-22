#!/usr/bin/perl

package RoutingTables;

use strict;
use feature 'say';

use Exporter;
our @ISA=qw(Exporter); 
our @EXPORT=qw();
use Scalar::Util 'refaddr';
use Data::Dumper;
use Time::HiRes 'gettimeofday';

use CallEventData;


my (%seenUUID,%localRoutes,%globalRT,%cid2mid,%sid2mid);

sub new
{
	my $class = shift;
	bless \do{my $v},$class;
}

sub mRoute
{
	my $self=shift;
	my $me=refaddr $self;
	say "adding to routes ",join(":",@_);
	$localRoutes{$me}->{$_[0]}->{$_[1]}->{sock}=$_[2] if @_ >=2;
	$localRoutes{$me}->{$_[0]}->{$_[1]}->{type}=$_[3] if @_ >=3;
	return $localRoutes{$me}->{$_[0]};
}

sub mRouteDel
{
	my $self=shift;
	die unless scalar(@_) == 2;
	my $me=refaddr $self;

#	my $dst=$_[1];
#	@{$localRoutes{$me}->{$_[0]}} = grep { $dst ne $_ }  @{$localRoutes{$me}->{$_[0]}};

	
	delete $localRoutes{$me}->{$_[0]}->{$_[1]};

	return $localRoutes{$me}->{$_[0]};
}

sub floodRoute
{
	my $self= shift;
	my $me= refaddr $self;
	my ($myID,$msg,$localProcessing) = @_;

	# if UUID forwarded already - drop it
	return if $seenUUID{$me}->{$msg->getRaw->{UUID}};
	# remember UUIDs for routed messages
	$seenUUID{$me}->{$msg->getRaw->{UUID}}=gettimeofday;

	my $dst= $msg->getRaw->{DEST};
	my $sock;
	say "message to $dst";
	# process events addressed locally
	if ($dst eq '_BCAST_' or $dst eq $myID)
	{
		if ($msg->getRaw->{METHOD} eq 'bcastRT')
		{
			my $dst = $msg->getRaw->{ARGVAL}->{SRC};
		  my $gdst;
			foreach $gdst (keys %{$msg->getRaw->{ARGVAL}->{rt}})
			{
				$globalRT{$me}->{$gdst} = $msg->getRaw->{ARGVAL}->{rt}->{$gdst};
			}
		}
		elsif ($msg->getRaw->{METHOD} eq 'bcastIP_PORT')
		{
			my $dst = $msg->getRaw->{SRC};
			my $bc_id = $msg->getRaw->{ARGVAL}->{id};
			if($bc_id ne $myID and $dst ne $myID)
			{
				my $bc_ip = $msg->getRaw->{ARGVAL}->{ip};
				my $bc_port = $msg->getRaw->{ARGVAL}->{port};
				if ( not grep { $bc_id eq $_ } (keys %{$localRoutes{$me}->{$myID}}) )
				{
					my $sock = new AuthenticatedLink($bc_ip,$bc_port);
					$self->mRoute($myID,$bc_id,$sock) if $sock;
				}
			}
		}
		else
		  { &$localProcessing($msg) }
	}
	# directly connected destination
	elsif(defined $localRoutes{$me}->{$myID}->{$dst})
	{
		print "sending to peer $dst: ",Dumper($localRoutes{$me}->{$myID});
		$sock=$localRoutes{$me}->{$myID}->{$dst}->{sock};
		$msg->sendData($sock)
	}
	# send to all connected MESS peers
	else
	{
		print "sending to all connected peers: ",Dumper($localRoutes{$me}->{$myID});
		foreach my $peer (keys %{$localRoutes{$me}->{$myID}})
		{
			$msg->sendData($localRoutes{$me}->{$myID}->{$peer}->{sock})
			  if $localRoutes{$me}->{$myID}->{$peer}->{type} eq 'MESS'
		}
	}
}

sub bcastLocalRT
{
	my $me = refaddr shift;
	my ($myID) = @_;
	#for all mess peers
	my $rtbe = new MessEvent($myID,'_BCAST_','bcastRT',{ 'rt' => $localRoutes{$me}},undef);
	floodRoute($myID,$rtbe)
}

sub bcastLocalIpPort
{
	my $self= shift;
	my $me = refaddr $self;
	die if @_ < 3;
	my ($myID,$ip,$port) = @_;
	#for all mess peers
	my $rtbe = new MessEvent($myID,'_BCAST_','bcastIP_PORT',{ 'id' => $myID, 'ip' => $ip, 'port' => $port},undef);
	my $callData = new CallEventData;
	$callData->setRaw($rtbe);
	$self->floodRoute($myID,$callData)
}

1;
